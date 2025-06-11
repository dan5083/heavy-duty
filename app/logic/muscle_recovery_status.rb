class MuscleRecoveryStatus
  attr_reader :workout_logs

  def initialize(workout_logs:)
    @workout_logs = workout_logs
  end

  def days_until_ready(muscle)
    last_trained = most_recent_log(muscle)&.created_at
    return 0 unless last_trained

    days_since = (Time.current.to_date - last_trained.to_date).to_i
    required_days = AppConstants::TRAINING_CYCLE[muscle] || 7
    [required_days - days_since, 0].max
  end

  def days_map
    AppConstants::TRAINING_CYCLE.keys.index_with { |muscle| days_until_ready(muscle) }
  end

  private

  def most_recent_log(muscle)
    workout_logs
      .joins(:workout)
      .where(workouts: { muscle_group: muscle })
      .order(created_at: :desc)
      .first
  end
end
