class WorkoutPresenter
  def initialize(workout)
    @workout = workout
    @log = workout.workout_logs.order(:created_at).last
  end

  def name
    @workout.name
  end

  def muscle_label
    AppConstants::LABELS[@workout.muscle_group.to_sym]
  end

  def log_date
    @log&.created_at&.strftime("%b %d, %Y") || "Unlogged"
  end

  def volume
    @log&.details.presence || "—"
  end

  def note
    @log&.details
  end

  def logged?
    @log.present?
  end
end
