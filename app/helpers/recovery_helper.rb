module RecoveryHelper
  # === EXISTING RECOVERY METHODS ===

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
    user_context.acting_user.split_plans.last&.split_days&.pluck(:muscle_group)&.map(&:to_sym)&.uniq || []
  end

  def log_path_for_muscle(muscle, workouts_by_muscle, view_mode = 'recovery')
    workout = workouts_by_muscle[muscle]
    return nil unless workout

    path = new_split_plan_split_day_workout_workout_log_path(
      workout.split_day.split_plan,
      workout.split_day,
      workout
    )

    # Preserve view mode in workout links
    if view_mode == 'benchmark'
      path += "?from_view=benchmark"
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

  # === NEW BENCHMARK METHODS ===

  def benchmark_status_for(muscle, benchmark_data)
    data = benchmark_data[muscle]
    return nil unless data

    if data[:has_benchmark]
      days_since = data[:days_since_benchmark]
      {
        status: benchmark_status_type(days_since),
        label: data[:benchmark_age_label],
        days_since: days_since,
        last_date: data[:last_benchmark_date],
        urgency: benchmark_urgency(days_since)
      }
    else
      {
        status: :never,
        label: "Never benchmarked",
        days_since: nil,
        last_date: nil,
        urgency: :critical
      }
    end
  end

  def benchmark_status_badge(benchmark_status)
    return tag.span("❌ Never", class: "badge bg-danger") unless benchmark_status

    case benchmark_status[:status]
    when :fresh
      tag.span("🆕 Fresh", class: "badge bg-success")
    when :good
      tag.span("✅ Good", class: "badge bg-primary")
    when :aging
      tag.span("⏳ Aging", class: "badge bg-warning text-dark")
    when :stale
      tag.span("🔄 Stale", class: "badge bg-danger")
    when :never
      tag.span("❌ Never", class: "badge bg-danger")
    else
      tag.span("❓ Unknown", class: "badge bg-secondary")
    end
  end

  def benchmark_urgency_class(urgency)
    case urgency
    when :critical
      "border-danger"
    when :high
      "border-warning"
    when :medium
      "border-info"
    when :low
      "border-success"
    else
      "border-secondary"
    end
  end

  def benchmark_progress_percentage(days_since)
    return 0 if days_since.nil?

    # Consider 30 days as 100% stale
    max_days = 30
    percentage = [(days_since.to_f / max_days * 100).round, 100].min

    # Invert so fresh benchmarks show high percentage
    100 - percentage
  end

  def benchmark_progress_color(days_since)
    return "bg-danger" if days_since.nil?

    case days_since
    when 0..7
      "bg-success"
    when 8..14
      "bg-primary"
    when 15..21
      "bg-warning"
    else
      "bg-danger"
    end
  end

  def benchmark_action_button_text(benchmark_status, view_mode)
    return "Set First Benchmark" unless benchmark_status&.dig(:has_benchmark)

    case view_mode
    when 'benchmark'
      case benchmark_status[:urgency]
      when :critical, :high
        "Update Benchmark"
      else
        "Beat Benchmark"
      end
    else
      "Start Workout"
    end
  end

  def benchmark_action_button_class(benchmark_status, muscle_ready = false)
    return "btn btn-warning btn-sm w-100" unless benchmark_status&.dig(:has_benchmark)

    case benchmark_status[:urgency]
    when :critical
      "btn btn-danger btn-sm w-100"
    when :high
      "btn btn-warning btn-sm w-100"
    when :medium
      muscle_ready ? "btn btn-success btn-sm w-100" : "btn btn-outline-primary btn-sm w-100"
    else
      muscle_ready ? "btn btn-success btn-sm w-100" : "btn btn-outline-light btn-sm w-100"
    end
  end

  # === VIEW MODE HELPERS ===

  def view_mode_toggle_links(current_view)
    recovery_class = current_view == 'recovery' ? 'btn-primary' : 'btn-outline-primary'
    benchmark_class = current_view == 'benchmark' ? 'btn-primary' : 'btn-outline-primary'

    content_tag(:div, class: "btn-group mb-3", role: "group") do
      link_to("Recovery View", dashboard_path(view: 'recovery'),
              class: "btn #{recovery_class}",
              data: { turbo_method: :get }) +
      link_to("Benchmark View", dashboard_path(view: 'benchmark'),
              class: "btn #{benchmark_class}",
              data: { turbo_method: :get })
    end
  end

  def view_mode_description(view_mode)
    case view_mode
    when 'benchmark'
      "Track when each muscle group was last benchmarked and needs updating"
    else
      "Track recovery status and when muscles are ready to train again"
    end
  end

  def next_ready_description(next_ready, view_mode)
    return nil unless next_ready

    case view_mode
    when 'benchmark'
      if next_ready[:needs_benchmark]
        "#{next_ready[:label]} has never been benchmarked"
      else
        "#{next_ready[:label]} benchmark is #{pluralize(next_ready[:days_since], 'day')} old"
      end
    else
      if next_ready[:days_ready] && next_ready[:days_ready] > 0
        "#{next_ready[:label]} has been ready for #{pluralize(next_ready[:days_ready], 'day')}"
      else
        "#{next_ready[:label]} will be ready in #{pluralize(next_ready[:days_left], 'day')}"
      end
    end
  end

  private

  def benchmark_status_type(days_since)
    case days_since
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

  def benchmark_urgency(days_since)
    case days_since
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
end
