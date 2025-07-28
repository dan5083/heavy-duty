# app/logic/recovery_tracker.rb
class RecoveryTracker
  def initialize(user)
    @user = user
    @preloaded_data = preload_all_workout_data
  end

  # 🆕 NEW: Expose preloaded data for external use
  def preloaded_data
    @preloaded_data
  end

  # === RECOVERY METHODS ===

  def ready_date_for(muscle)
    last_log = @preloaded_data[:latest_by_muscle][muscle.to_s]
    return Date.today if last_log.nil?

    cooldown = AppConstants::TRAINING_CYCLE[muscle]
    last_log.created_at + cooldown.days
  end

  def countdown_days_for(muscle)
    ready_date = ready_date_for(muscle).to_date
    (ready_date - Date.today).to_i
  end

  def forecast(days_ahead: 10)
    AppConstants::TRAINING_CYCLE.keys.index_with do |muscle|
      ready_on = ready_date_for(muscle)
      Array.new(days_ahead) do |offset|
        day = Date.today + offset
        day >= ready_on ? :ready : :recovering
      end
    end
  end

  def next_ready_muscle
    future_recovery = AppConstants::TRAINING_CYCLE.keys.map do |muscle|
      ready_on = ready_date_for(muscle)
      next if ready_on <= Date.today # already ready

      [muscle, ready_on]
    end.compact

    return nil if future_recovery.empty?

    muscle, date = future_recovery.min_by { |_, d| d }

    {
      muscle: muscle,
      label: AppConstants::LABELS[muscle],
      ready_on: date,
      days_left: (date - Date.today).to_i
    }
  end

  def full_map
    AppConstants::TRAINING_CYCLE.keys.index_with do |muscle|
      ready_on = ready_date_for(muscle)
      days_left = countdown_days_for(muscle)

      {
        ready_on: ready_on,
        days_left: days_left,
        days_ready: days_left <= 0 ? days_left.abs : nil,
        label: AppConstants::LABELS[muscle]
      }.merge(benchmark_data_for(muscle))
    end
  end

  # === BENCHMARK METHODS ===

  def last_benchmark_date_for(muscle)
    benchmark_log = @preloaded_data[:benchmarks_by_muscle][muscle.to_s]
    benchmark_log&.created_at&.to_date
  end

  def days_since_benchmark_for(muscle)
    last_benchmark = last_benchmark_date_for(muscle)
    return nil if last_benchmark.nil?

    (Date.today - last_benchmark).to_i
  end

  def has_benchmark_for?(muscle)
    @preloaded_data[:benchmarks_by_muscle][muscle.to_s].present?
  end

  def benchmark_map
    AppConstants::TRAINING_CYCLE.keys.index_with do |muscle|
      benchmark_data_for(muscle)
    end
  end

  def oldest_benchmark
    benchmarks_with_dates = AppConstants::TRAINING_CYCLE.keys.map do |muscle|
      days_since = days_since_benchmark_for(muscle)
      next if days_since.nil?

      {
        muscle: muscle,
        label: AppConstants::LABELS[muscle],
        days_since: days_since,
        last_benchmark_date: last_benchmark_date_for(muscle)
      }
    end.compact

    return nil if benchmarks_with_dates.empty?

    benchmarks_with_dates.max_by { |data| data[:days_since] }
  end

  def newest_benchmark
    benchmarks_with_dates = AppConstants::TRAINING_CYCLE.keys.map do |muscle|
      days_since = days_since_benchmark_for(muscle)
      next if days_since.nil?

      {
        muscle: muscle,
        label: AppConstants::LABELS[muscle],
        days_since: days_since,
        last_benchmark_date: last_benchmark_date_for(muscle)
      }
    end.compact

    return nil if benchmarks_with_dates.empty?

    benchmarks_with_dates.min_by { |data| data[:days_since] }
  end

  def muscles_needing_benchmarks
    AppConstants::TRAINING_CYCLE.keys.select do |muscle|
      !has_benchmark_for?(muscle)
    end
  end

  private

  # 🚀 OPTIMIZED: Single query with comprehensive preloading
  def preload_all_workout_data
    # Single query to get all workout logs with workouts preloaded
    # Force execution immediately to prevent multiple queries later
    all_logs = @user.workout_logs
                   .includes(:workout)
                   .order(created_at: :desc)
                   .load  # Force immediate execution

    # Group by muscle group and get the latest for each
    latest_by_muscle = {}
    benchmarks_by_muscle = {}

    all_logs.each do |log|
      # Use preloaded workout association (no additional query)
      muscle_group = log.workout.muscle_group

      # Track latest workout per muscle group
      latest_by_muscle[muscle_group] ||= log

      # Track latest benchmark per muscle group (only default variations to avoid confusion)
      if log.is_benchmark? && log.is_default_variation? && !benchmarks_by_muscle[muscle_group]
        benchmarks_by_muscle[muscle_group] = log
      end
    end

    {
      latest_by_muscle: latest_by_muscle,
      benchmarks_by_muscle: benchmarks_by_muscle,
      all_logs: all_logs  # Cache the loaded data for reuse
    }
  end

  def benchmark_data_for(muscle)
    benchmark_log = @preloaded_data[:benchmarks_by_muscle][muscle.to_s]
    last_benchmark = benchmark_log&.created_at&.to_date
    days_since = last_benchmark ? (Date.today - last_benchmark).to_i : nil

    {
      last_benchmark_date: last_benchmark,
      days_since_benchmark: days_since,
      has_benchmark: last_benchmark.present?,
      benchmark_age_label: benchmark_age_label(days_since)
    }
  end

  def benchmark_age_label(days_since)
    return "Never benchmarked" if days_since.nil?

    case days_since
    when 0
      "Today"
    when 1
      "Yesterday"
    when 2..6
      "#{days_since} days ago"
    when 7..13
      "1 week ago"
    when 14..29
      "#{(days_since / 7.0).round} weeks ago"
    when 30..89
      "#{(days_since / 30.0).round} months ago"
    else
      "#{(days_since / 365.0).round} years ago"
    end
  end
end
