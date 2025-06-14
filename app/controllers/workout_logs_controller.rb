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
      # Handle benchmark updates with exercise-by-exercise merging
      if beat_benchmark && formatted_details.present?
        updated_benchmark = merge_benchmark_selectively(parsed)
        @workout.update(details: updated_benchmark.to_json)

        redirect_to split_plan_split_day_path(@workout.split_day.split_plan, @workout.split_day),
                    notice: "Workout saved and benchmark updated! 🎉"
      else
        redirect_to split_plan_split_day_path(@workout.split_day.split_plan, @workout.split_day),
                    notice: "Workout saved."
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

  def merge_benchmark_selectively(new_workout_data)
    # Get current benchmark data
    current_benchmark = {}
    if @workout.details.present?
      begin
        current_benchmark = JSON.parse(@workout.details)
      rescue JSON::ParserError
        current_benchmark = {}
      end
    end

    # Start with current benchmark as base
    updated_benchmark = current_benchmark.dup

    # For each exercise in the new workout, determine if it should update the benchmark
    new_workout_data.each do |exercise_name, new_sets|
      current_sets = current_benchmark[exercise_name] || []

      # Simple heuristic: if the user changed the text from benchmark, they probably improved
      if sets_were_modified?(current_sets, new_sets)
        updated_benchmark[exercise_name] = new_sets
        Rails.logger.info "Updated benchmark for #{exercise_name}: #{new_sets}"
      else
        # Keep existing benchmark for this exercise
        Rails.logger.info "Kept existing benchmark for #{exercise_name}"
      end
    end

    updated_benchmark
  end

  def sets_were_modified?(original_sets, new_sets)
    # If no original benchmark, any new data is an improvement
    return true if original_sets.empty? && new_sets.any?

    # If different number of sets, it was modified
    return true if original_sets.length != new_sets.length

    # Check if any set descriptions were actually changed
    original_sets.each_with_index do |original_set, index|
      new_set = new_sets[index]
      next unless new_set # Skip if new set doesn't exist

      # Normalize whitespace and compare
      original_normalized = original_set.to_s.strip.downcase
      new_normalized = new_set.to_s.strip.downcase

      # If any set was changed, consider it modified
      return true if original_normalized != new_normalized
    end

    # No meaningful changes detected
    false
  end
end
