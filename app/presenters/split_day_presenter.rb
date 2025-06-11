class SplitDayPresenter
  def initialize(split_day)
    @split_day = split_day
  end

  def muscle_label
    AppConstants::LABELS[@split_day.muscle_group.to_sym]
  end

  def workout_name
    @split_day.workouts.first&.name
  end

  def latest_log
    @split_day.workouts.first&.workout_logs&.order(:created_at)&.last
  end

  def note
    latest_log&.details.presence || "—"
  end
end
