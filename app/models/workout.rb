class Workout < ApplicationRecord
  has_many :workout_logs
  has_one :benchmark_log, -> { where(is_benchmark: true) }, class_name: 'WorkoutLog'
  belongs_to :split_day

  def benchmark_exercises
    return {} unless benchmark_log
    benchmark_log.exercises_hash
  end

  def starter_template
    benchmark_exercises.presence || default_template
  end

  def benchmark_summary
    return {} unless benchmark_log
    benchmark_log.exercises_summary
  end

  private

  def default_template
    # Return empty hash - will be handled by frontend
    {}
  end
end
