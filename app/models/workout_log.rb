class WorkoutLog < ApplicationRecord
  belongs_to :user
  belongs_to :workout
  has_many :exercise_sets, dependent: :destroy

  # Remove the exercise_sets presence validation - we'll validate after creation
  validate :only_one_benchmark_per_workout
  validate :has_exercise_sets_after_save, on: :update

  # Move the callback to run BEFORE validation
  before_validation :clear_other_benchmarks, if: :is_benchmark?

  # === NEW BENCHMARK SCOPES ===

  # Get only benchmark workout logs
  scope :benchmarks_only, -> { where(is_benchmark: true) }

  # Get only non-benchmark workout logs
  scope :regular_workouts, -> { where(is_benchmark: false) }

  # Get latest benchmark per muscle group for a user
  scope :latest_benchmark_per_muscle, -> {
    benchmarks_only
      .joins(:workout)
      .select('workout_logs.*, workouts.muscle_group, ROW_NUMBER() OVER (PARTITION BY workouts.muscle_group ORDER BY workout_logs.created_at DESC) as rn')
      .where('rn = 1')
  }

  # Get benchmarks for specific muscle groups
  scope :benchmarks_for_muscles, ->(muscles) {
    benchmarks_only
      .joins(:workout)
      .where(workouts: { muscle_group: muscles })
  }

  # Get benchmarks within date range
  scope :benchmarks_between, ->(start_date, end_date) {
    benchmarks_only.where(created_at: start_date..end_date)
  }

  # Order by most recent benchmarks first
  scope :recent_benchmarks_first, -> { benchmarks_only.order(created_at: :desc) }

  # Get benchmarks older than X days
  scope :benchmarks_older_than, ->(days) {
    benchmarks_only.where('created_at < ?', days.days.ago)
  }

  # === NEW BENCHMARK INSTANCE METHODS ===

  def benchmark?
    is_benchmark?
  end

  def days_since_benchmark
    return nil unless is_benchmark?
    (Date.today - created_at.to_date).to_i
  end

  def benchmark_age_label
    return "Not a benchmark" unless is_benchmark?

    days = days_since_benchmark

    case days
    when 0
      "Set today"
    when 1
      "Set yesterday"
    when 2..6
      "Set #{days} days ago"
    when 7..13
      "Set 1 week ago"
    when 14..29
      "Set #{(days / 7.0).round} weeks ago"
    when 30..89
      "Set #{(days / 30.0).round} months ago"
    else
      "Set #{(days / 365.0).round} years ago"
    end
  end

  def muscle_group
    workout&.muscle_group
  end

  def muscle_label
    return nil unless muscle_group
    AppConstants::LABELS[muscle_group.to_sym] || muscle_group.humanize
  end

  # === CLASS METHODS FOR BENCHMARK ANALYTICS ===

  def self.benchmark_summary_for_user(user)
    benchmarks = user.workout_logs.benchmarks_only.includes(:workout)

    {
      total_benchmarks: benchmarks.count,
      muscles_with_benchmarks: benchmarks.joins(:workout).distinct.count('workouts.muscle_group'),
      oldest_benchmark: benchmarks.order(:created_at).first,
      newest_benchmark: benchmarks.order(:created_at).last,
      average_days_between_benchmarks: calculate_average_benchmark_interval(benchmarks)
    }
  end

  def self.muscles_needing_benchmarks_for_user(user, muscles_in_split)
    benchmarked_muscles = user.workout_logs
                             .benchmarks_only
                             .joins(:workout)
                             .distinct
                             .pluck('workouts.muscle_group')
                             .map(&:to_sym)

    muscles_in_split - benchmarked_muscles
  end

  # === EXISTING METHODS ===

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

  def self.calculate_average_benchmark_interval(benchmarks)
    return nil if benchmarks.count < 2

    ordered_benchmarks = benchmarks.order(:created_at)
    intervals = []

    ordered_benchmarks.each_cons(2) do |older, newer|
      intervals << (newer.created_at.to_date - older.created_at.to_date).to_i
    end

    intervals.sum / intervals.size.to_f
  end
end
