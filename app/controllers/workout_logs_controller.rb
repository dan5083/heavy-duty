class WorkoutLogsController < ApplicationController
  before_action :set_workout

  def index
    @workout_logs = @workout.workout_logs
  end

  def new
    @log = @workout.workout_logs.new
  end

  def create
    raw_details = workout_log_params[:details]
    beat_benchmark = params[:beat_benchmark] == 'yes'

    # Defensive parse for safety
    begin
      parsed = JSON.parse(raw_details)
      raise unless parsed.is_a?(Hash) && parsed.any?

      formatted_details = JSON.pretty_generate(parsed)
    rescue
      formatted_details = raw_details.to_s.strip
    end

    @log = @workout.workout_logs.build(details: formatted_details, user: current_user)

    if @log.save
      # Handle benchmark updates - simplified logic
      if beat_benchmark && formatted_details.present?
        begin
          # User explicitly chose to update benchmark - use their submitted data
          updated_benchmark = JSON.parse(formatted_details)
          @workout.update(details: updated_benchmark.to_json)

          Rails.logger.info "Benchmark updated with user's workout data"

          # FIXED: Redirect to training archive instead of split plan
          redirect_to training_archive_path,
                      notice: "Workout saved and benchmark updated! 🎉"
        rescue JSON::ParserError => e
          Rails.logger.error "Failed to parse workout details for benchmark update: #{e.message}"

          # FIXED: Redirect to training archive instead of split plan
          redirect_to training_archive_path,
                      notice: "Workout saved, but benchmark update failed."
        end
      else
        # User chose just to save workout without updating benchmark
        # FIXED: Redirect to training archive instead of split plan
        redirect_to training_archive_path,
                    notice: "Workout saved."
      end
    else
      # If save failed, render the form again with errors
      render :new, status: :unprocessable_entity
    end
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

  def workout_log_params
    params.require(:workout_log).permit(:details)
  end

  # REMOVED: Complex merge_benchmark_selectively method
  # REMOVED: Complex sets_were_modified? method
  #
  # Simplified approach: If user says "update benchmark", use their data.
  # If they say "just save", keep existing benchmark unchanged.
end
