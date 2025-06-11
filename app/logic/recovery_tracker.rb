# app/logic/recovery_tracker.rb
class RecoveryTracker
  def initialize(user)
    @user = user
  end

  def ready_date_for(muscle)
    last_log = @user.workout_logs
                    .joins(:workout)
                    .where(workouts: { muscle_group: muscle })
                    .order(created_at: :desc)
                    .first

    return Date.today if last_log.nil?

    cooldown = AppConstants::TRAINING_CYCLE[muscle]
    last_log.created_at.to_date + cooldown
  end

  def countdown_days_for(muscle)
    (ready_date_for(muscle) - Date.today).to_i
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
      }
    end
  end
end
