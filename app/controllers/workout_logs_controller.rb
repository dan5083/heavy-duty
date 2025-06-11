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
      # Update benchmark if user beat it
      if beat_benchmark && formatted_details.present?
        @workout.update(details: formatted_details)
        redirect_to split_plan_split_day_path(@workout.split_day.split_plan, @workout.split_day),
                    notice: "Log created and benchmark updated! 🎉"
      else
        redirect_to split_plan_split_day_path(@workout.split_day.split_plan, @workout.split_day),
                    notice: "Log created."
      end
    else
      render :new
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
end
