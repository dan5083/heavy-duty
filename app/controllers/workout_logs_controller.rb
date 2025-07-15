# app/controllers/workout_logs_controller.rb

class WorkoutLogsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_can_act_on_behalf!
  before_action :set_workout

  def index
    @workout_logs = @workout.workout_logs
  end

  def new
    @log = @workout.workout_logs.new
  end

  def create
    Rails.logger.info "🏋️ Starting workout log creation"
    Rails.logger.info "🏋️ Params: #{params.except(:authenticity_token).to_json}"
    Rails.logger.info "🏋️ Current user: #{current_user.email} (#{current_user.id})"
    Rails.logger.info "🏋️ Acting user: #{user_context.acting_user.email} (#{user_context.acting_user.id})"
    Rails.logger.info "🏋️ Impersonation mode: #{user_context.impersonation_mode?}"
    Rails.logger.info "🏋️ beat_benchmark param: #{params[:beat_benchmark].inspect}"
    Rails.logger.info "🏋️ exercise_context param: #{params[:exercise_context].inspect}"
    Rails.logger.info "🏋️ workout_datetime param: #{params[:workout_datetime].inspect}"

    # Use acting_user instead of viewing_user
    @log = @workout.workout_logs.build(user: user_context.acting_user)

    # 🆕 NEW: Set exercise context if provided
    @log.exercise_context = params[:exercise_context] if params[:exercise_context].present?

    # 🆕 NEW: Handle custom workout timing
    workout_datetime = determine_workout_datetime
    if workout_datetime.nil? && params[:workout_datetime].present?
      # There was an error with the custom datetime
      redirect_to new_split_plan_split_day_workout_workout_log_path(@workout.split_day.split_plan, @workout.split_day, @workout),
                  alert: flash[:alert] || "Invalid workout date/time. Please try again."
      return
    end

    # Set custom datetime if provided (nil means use current time)
    @log.created_at = workout_datetime if workout_datetime

    Rails.logger.info "🏋️ Created workout log for user: #{@log.user.email} (#{@log.user.id})"
    Rails.logger.info "🏋️ Exercise context: #{@log.exercise_context.inspect}"
    Rails.logger.info "🏋️ Workout datetime: #{workout_datetime || 'current time'}"

    # Parse the exercise sets from params
    begin
      exercise_sets_data = JSON.parse(params[:exercise_sets] || '[]')
      Rails.logger.info "🏋️ Parsed exercise sets: #{exercise_sets_data.length} sets"
      Rails.logger.info "🏋️ Exercise sets data: #{exercise_sets_data.to_json}"
    rescue JSON::ParserError => e
      Rails.logger.error "❌ Failed to parse exercise sets JSON: #{e.message}"
      Rails.logger.error "❌ Raw exercise_sets param: #{params[:exercise_sets].inspect}"
      redirect_to dashboard_path, alert: "Failed to save workout data - invalid exercise data."
      return
    end

    beat_benchmark = params[:beat_benchmark] == 'yes'
    Rails.logger.info "🏋️ Beat benchmark: #{beat_benchmark}"

    ActiveRecord::Base.transaction do
      Rails.logger.info "🏋️ Starting database transaction"

      # Save the workout log first
      if @log.save
        Rails.logger.info "✅ Workout log saved with ID: #{@log.id}"
        Rails.logger.info "✅ Workout log created_at: #{@log.created_at}"

        # Create exercise sets
        exercise_sets_data.each_with_index do |set_data, index|
          Rails.logger.info "🏋️ Creating exercise set #{index + 1}: #{set_data.inspect}"

          exercise_set = @log.exercise_sets.build(
            exercise_name: set_data['exercise_name'],
            set_number: set_data['set_number'],
            set_type: set_data['set_type'] || 'working',
            reps: set_data['reps'],
            weight_kg: set_data['weight_kg'],
            weight_unit: set_data['weight_unit'] || 'kg',
            notes: set_data['notes']
          )

          # 🆕 NEW: Handle cardio fields if present
          if set_data['duration_seconds'].present?
            exercise_set.duration_seconds = set_data['duration_seconds']
          end

          if set_data['energy_calories'].present?
            exercise_set.energy_calories = set_data['energy_calories']
          end

          if exercise_set.save
            Rails.logger.info "✅ Exercise set #{index + 1} saved with ID: #{exercise_set.id}"
          else
            Rails.logger.error "❌ Failed to save exercise set #{index + 1}: #{exercise_set.errors.full_messages.join(', ')}"
            raise ActiveRecord::RecordInvalid, exercise_set
          end
        end

        Rails.logger.info "✅ All exercise sets created successfully"

        # Log the workout creation
        log_audit_action(
          action: 'create_workout_log',
          resource: @log,
          metadata: {
            exercise_count: exercise_sets_data.length,
            beat_benchmark: beat_benchmark,
            muscle_group: @workout.muscle_group,
            workout_id: @workout.id,
            acting_user_id: user_context.acting_user.id,
            has_exercise_context: @log.has_context?, # 🆕 NEW: Track context usage
            custom_datetime: workout_datetime.present?, # 🆕 NEW: Track custom timing usage
            workout_datetime: @log.created_at.iso8601 # 🆕 NEW: Log the actual workout time
          }
        )

        # Handle benchmark choice
        if beat_benchmark
          Rails.logger.info "🏆 Setting as benchmark"

          # Check if there are existing benchmarks for this workout
          existing_benchmarks = @workout.workout_logs.where(is_benchmark: true)
          Rails.logger.info "🏆 Existing benchmarks for this workout: #{existing_benchmarks.count}"

          if @log.update!(is_benchmark: true)
            Rails.logger.info "✅ Benchmark status updated successfully"

            # Log benchmark update
            log_audit_action(
              action: 'update_benchmark',
              resource: @log,
              metadata: {
                muscle_group: @workout.muscle_group,
                previous_benchmark_count: existing_benchmarks.count,
                has_exercise_context: @log.has_context?, # 🆕 NEW: Track context in benchmarks
                custom_datetime: workout_datetime.present?, # 🆕 NEW: Track custom timing in benchmarks
                workout_datetime: @log.created_at.iso8601 # 🆕 NEW: Log benchmark datetime
              }
            )

            # 🆕 NEW: Different success message based on timing
            success_message = if workout_datetime
              "Workout saved and benchmark updated! 🎉 (Logged for #{@log.created_at.strftime('%b %d at %I:%M %p')})"
            else
              "Workout saved and benchmark updated! 🎉"
            end

            Rails.logger.info "🎉 Redirecting to dashboard with benchmark success message"
            redirect_to dashboard_path, notice: success_message
          else
            Rails.logger.error "❌ Failed to update benchmark status: #{@log.errors.full_messages.join(', ')}"
            raise ActiveRecord::RecordInvalid, @log
          end
        else
          Rails.logger.info "📝 Not setting as benchmark - regular workout save"

          # 🆕 NEW: Success message considers context and timing
          success_parts = []
          success_parts << "Workout saved"
          success_parts << "with context notes" if @log.has_context?

          if workout_datetime
            success_parts << "(logged for #{@log.created_at.strftime('%b %d at %I:%M %p')})"
          end

          success_message = success_parts.join(" ") + "."

          redirect_to dashboard_path, notice: success_message
        end
      else
        Rails.logger.error "❌ Failed to save workout log: #{@log.errors.full_messages.join(', ')}"
        Rails.logger.error "❌ Workout log attributes: #{@log.attributes.inspect}"
        render :new, status: :unprocessable_entity
      end
    end
  rescue JSON::ParserError => e
    Rails.logger.error "❌ JSON parsing error in workout creation: #{e.message}"
    redirect_to dashboard_path, alert: "Failed to save workout data."
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "❌ Database validation error in workout creation: #{e.message}"
    Rails.logger.error "❌ Full backtrace: #{e.backtrace.first(5).join('\n')}"
    redirect_to dashboard_path, alert: "Failed to save workout: #{e.message}"
  rescue StandardError => e
    Rails.logger.error "❌ Unexpected error in workout creation: #{e.class.name}: #{e.message}"
    Rails.logger.error "❌ Full backtrace: #{e.backtrace.first(10).join('\n')}"
    redirect_to dashboard_path, alert: "An unexpected error occurred while saving your workout."
  end

  def render_set_inputs
    @exercises = params[:exercise_names] || []

    render turbo_stream: turbo_stream.replace(
      "log_builder",
      partial: "workout_logs/set_input_fields",
      locals: { exercises: @exercises, workout: @workout }
    )
  end

  private

  def set_workout
    @workout = Workout.find(params[:workout_id])
    Rails.logger.info "🎯 Set workout: #{@workout.name} (ID: #{@workout.id}) for muscle group: #{@workout.muscle_group}"
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "❌ Workout not found: #{params[:workout_id]}"
    redirect_to dashboard_path, alert: "Workout not found."
  end

  # 🆕 NEW: Determine workout datetime from params
  def determine_workout_datetime
    # If no custom datetime provided, use current time (return nil for ActiveRecord default)
    return nil unless params[:workout_datetime].present?

    begin
      custom_datetime = DateTime.parse(params[:workout_datetime])

      # Validate it's not in the future
      if custom_datetime > Time.current
        flash[:alert] = "Workout time cannot be in the future."
        Rails.logger.warn "🕐 Attempted future workout time: #{custom_datetime}"
        return nil
      end

      # Validate it's not too far in the past (e.g., 1 year)
      if custom_datetime < 1.year.ago
        flash[:alert] = "Workout time cannot be more than 1 year ago."
        Rails.logger.warn "🕐 Attempted workout time too far in past: #{custom_datetime}"
        return nil
      end

      # Convert to current timezone for consistency
      converted_datetime = custom_datetime.in_time_zone(Time.zone)

      Rails.logger.info "🕐 Using custom workout time: #{converted_datetime} (original: #{custom_datetime})"
      return converted_datetime

    rescue ArgumentError => e
      Rails.logger.error "🕐 Invalid datetime format: #{params[:workout_datetime]} - #{e.message}"
      flash[:alert] = "Invalid date/time format. Please check your input."
      return nil
    end
  end

  # 🆕 NEW: Updated strong parameters to include exercise_context and workout_datetime
  def workout_log_params
    params.require(:workout_log).permit(:exercise_context, :is_benchmark)
  end
end
