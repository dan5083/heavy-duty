module RecoveryHelper
  def readiness_label(ready_on_date)
    now = Time.current
    return "Good to Go" if ready_on_date <= now

    diff = ready_on_date - now
    days = (diff / 1.day).floor
    hours = ((diff % 1.day) / 1.hour).floor
    minutes = ((diff % 1.hour) / 1.minute).floor

    "Ready in #{days}d #{hours}h #{minutes}m"
  end

  def readiness_status_badge(days_left)
    if days_left <= 0
      tag.span("✅ Ready", class: "badge bg-success")
    elsif days_left <= 2
      tag.span("⏳ Soon", class: "badge bg-warning text-dark")
    else
      tag.span("🛑 Recovering", class: "badge bg-secondary")
    end
  end

  def current_split_muscles
    viewing_user.split_plans.last&.split_days&.pluck(:muscle_group)&.map(&:to_sym)&.uniq || []
  end

  def log_path_for_muscle(muscle, workouts_by_muscle)
    workout = workouts_by_muscle[muscle]
    return nil unless workout

    path = new_split_plan_split_day_workout_workout_log_path(
      workout.split_day.split_plan,
      workout.split_day,
      workout
    )

    # Add client_id if viewing as trainer
    if params[:client_id].present?
      path += "?client_id=#{params[:client_id]}"
    end

    path
  end

  def readiness_label(days_left)
    if days_left <= 0
      content_tag(:span, "✅ Good to Go", class: "text-success fw-bold")
    else
      content_tag(:span,
        "Ready in #{pluralize(days_left, 'day')}",
        class: "text-muted")
    end
  end
end
