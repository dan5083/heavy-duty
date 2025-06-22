class WorkoutLog < ApplicationRecord
  belongs_to :user
  belongs_to :workout
  has_many :exercise_sets, dependent: :destroy

  # Remove the exercise_sets presence validation - we'll validate after creation
  validate :only_one_benchmark_per_workout
  validate :has_exercise_sets_after_save, on: :update

  # Move the callback to run BEFORE validation
  before_validation :clear_other_benchmarks, if: :is_benchmark?

  def exercises_hash
    exercise_sets.includes(:workout_log).group_by(&:exercise_name)
  end

  def exercises_summary
    exercises_hash.transform_values do |sets|
      sets.map(&:description)
    end
  end

  private

  def only_one_benchmark_per_workout
    if is_benchmark? && workout.workout_logs.where(is_benchmark: true).where.not(id: id).exists?
      errors.add(:is_benchmark, "Only one benchmark allowed per workout")
    end
  end

  # This now runs BEFORE validation, so it clears other benchmarks first
  def clear_other_benchmarks
    workout.workout_logs.where(is_benchmark: true).where.not(id: id).update_all(is_benchmark: false)
  end

  def has_exercise_sets_after_save
    if persisted? && exercise_sets.empty?
      errors.add(:exercise_sets, "can't be blank")
    end
  end
end
