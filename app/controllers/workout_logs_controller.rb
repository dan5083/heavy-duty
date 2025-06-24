class WorkoutLogsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_can_view_user!, if: -> { params[:client_id] }
  before_action :set_workout

  def index
    @workout_logs = @workout.workout_logs
  end

  def new
    @log = @workout.workout_logs.new
  end

  def create
    Rails.logger.info "DEBUG: beat_benchmark param = #{params[:beat_benchmark].inspect}"

    @log = @workout.workout_logs.build(user: viewing_user)

    # Parse the exercise sets from params
    exercise_sets_data = JSON.parse(params[:exercise_sets] || '[]')
    beat_benchmark = params[:beat_benchmark] == 'yes'

    ActiveRecord::Base.transaction do
      if @log.save
        # Create exercise sets
        exercise_sets_data.each do |set_data|
          @log.exercise_sets.create!(
            exercise_name: set_data['exercise_name'],
            set_number: set_data['set_number'],
            set_type: set_data['set_type'] || 'working',
            reps: set_data['reps'],
            weight_kg: set_data['weight_kg'],
            weight_unit: set_data['weight_unit'] || 'kg',
            notes: set_data['notes']
          )
        end

        # Handle benchmark choice
        if beat_benchmark
          @log.update!(is_benchmark: true)
          redirect_to dashboard_path(client_id: params[:client_id]), notice: "Workout saved and benchmark updated! 🎉"
        else
          redirect_to dashboard_path(client_id: params[:client_id]), notice: "Workout saved."
        end
      else
        render :new, status: :unprocessable_entity
      end
    end
  rescue JSON::ParserError => e
    Rails.logger.error "Failed to parse exercise sets: #{e.message}"
    redirect_to dashboard_path(client_id: params[:client_id]), alert: "Failed to save workout data."
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to save exercise sets: #{e.message}"
    redirect_to dashboard_path(client_id: params[:client_id]), alert: "Failed to save workout: #{e.message}"
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
  end
end
