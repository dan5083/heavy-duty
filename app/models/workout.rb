class Workout < ApplicationRecord
  has_many :workout_logs
  has_one :benchmark_log, -> { where(is_benchmark: true) }, class_name: 'WorkoutLog'
  belongs_to :split_day

  # === EXISTING BENCHMARK METHODS ===

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

  # === NEW BENCHMARK HELPER METHODS ===

  def has_benchmark?
    benchmark_log.present?
  end

  def days_since_benchmark
    return nil unless has_benchmark?
    (Date.today - benchmark_log.created_at.to_date).to_i
  end

  def benchmark_age_status
    return :never unless has_benchmark?

    days = days_since_benchmark
    case days
    when 0..7
      :fresh
    when 8..14
      :good
    when 15..21
      :aging
    else
      :stale
    end
  end

  def benchmark_age_label
    return "Never benchmarked" unless has_benchmark?

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

  def has_recent_benchmark?(days_threshold = 14)
    return false unless has_benchmark?
    days_since_benchmark <= days_threshold
  end

  def benchmark_urgency
    return :critical unless has_benchmark?

    days = days_since_benchmark
    case days
    when 0..7
      :low
    when 8..14
      :medium
    when 15..21
      :high
    else
      :critical
    end
  end

  def benchmark_freshness_percentage
    return 0 unless has_benchmark?

    days = days_since_benchmark
    max_fresh_days = 30

    # Calculate freshness as inverse of age (newer = higher percentage)
    freshness = [(max_fresh_days - days).to_f / max_fresh_days * 100, 0].max.round
    [freshness, 100].min
  end

  # === WORKOUT LOG ANALYSIS ===

  def total_workout_logs_count
    workout_logs.count
  end

  def regular_workout_logs_count
    workout_logs.regular_workouts.count
  end

  def last_workout_date
    workout_logs.order(:created_at).last&.created_at&.to_date
  end

  def workout_frequency_days
    return nil if workout_logs.count < 2

    first_workout = workout_logs.order(:created_at).first
    last_workout = workout_logs.order(:created_at).last

    total_days = (last_workout.created_at.to_date - first_workout.created_at.to_date).to_i
    return nil if total_days == 0

    (total_days.to_f / (workout_logs.count - 1)).round(1)
  end

  def needs_benchmark_update?
    !has_recent_benchmark?(21) # Needs update if no benchmark in 3 weeks
  end

  # === COMPARISON METHODS ===

  def benchmark_vs_latest_comparison
    return nil unless has_benchmark?

    latest_regular = workout_logs.regular_workouts.order(:created_at).last
    return nil unless latest_regular

    {
      benchmark: benchmark_summary,
      latest: latest_regular.exercises_summary,
      benchmark_date: benchmark_log.created_at.to_date,
      latest_date: latest_regular.created_at.to_date,
      days_between: (latest_regular.created_at.to_date - benchmark_log.created_at.to_date).to_i
    }
  end

  # === SCOPES FOR WORKOUT COLLECTIONS ===

  scope :with_benchmarks, -> { joins(:workout_logs).where(workout_logs: { is_benchmark: true }).distinct }
  scope :without_benchmarks, -> {
    left_joins(:workout_logs)
      .where(workout_logs: { is_benchmark: [false, nil] })
      .or(where(workout_logs: { id: nil }))
      .distinct
  }
  scope :with_stale_benchmarks, ->(days = 21) {
    joins(:workout_logs)
      .where(workout_logs: { is_benchmark: true })
      .where('workout_logs.created_at < ?', days.days.ago)
      .distinct
  }
  scope :by_muscle_group, ->(muscle) { joins(:split_day).where(split_days: { muscle_group: muscle }) }

  # === CLASS METHODS FOR ANALYTICS ===

  def self.benchmark_statistics_for_split(split_plan)
    workouts = joins(:split_day).where(split_days: { split_plan: split_plan })

    total_workouts = workouts.count
    with_benchmarks = workouts.with_benchmarks.count
    without_benchmarks = workouts.without_benchmarks.count
    stale_benchmarks = workouts.with_stale_benchmarks.count

    {
      total_workouts: total_workouts,
      with_benchmarks: with_benchmarks,
      without_benchmarks: without_benchmarks,
      stale_benchmarks: stale_benchmarks,
      benchmark_coverage: total_workouts > 0 ? (with_benchmarks.to_f / total_workouts * 100).round(1) : 0,
      freshness_score: calculate_freshness_score(workouts)
    }
  end

  def self.muscles_needing_benchmark_attention(split_plan, staleness_threshold = 21)
    workouts = joins(:split_day).where(split_days: { split_plan: split_plan }).includes(:split_day, :workout_logs)

    needs_attention = workouts.select do |workout|
      !workout.has_benchmark? || workout.days_since_benchmark > staleness_threshold
    end

    needs_attention.map do |workout|
      {
        workout: workout,
        muscle_group: workout.split_day.muscle_group,
        muscle_label: AppConstants::LABELS[workout.split_day.muscle_group.to_sym],
        issue: workout.has_benchmark? ? :stale : :missing,
        days_since: workout.days_since_benchmark,
        urgency: workout.benchmark_urgency
      }
    end.sort_by { |item| item[:urgency] == :critical ? 0 : 1 }
  end

  private

  def default_template
    # Return empty hash - will be handled by frontend
    {}
  end

  def self.calculate_freshness_score(workouts)
    return 0 if workouts.empty?

    scores = workouts.map do |workout|
      if workout.has_benchmark?
        # Score from 0-100 based on how fresh the benchmark is
        days = workout.days_since_benchmark
        case days
        when 0..7
          100
        when 8..14
          75
        when 15..21
          50
        when 22..30
          25
        else
          0
        end
      else
        0 # No benchmark = 0 score
      end
    end

    (scores.sum.to_f / scores.size).round(1)
  end
end
