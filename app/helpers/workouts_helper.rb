module WorkoutsHelper
  def render_log_details(workout_log)
    return content_tag(:em, "No exercises recorded") if !workout_log.has_exercise_data?

    content_tag(:div) do
      # 🆕 NEW: Show exercise context if present
      context_html = if workout_log.has_context?
        content_tag(:div, class: "exercise-context-display mb-3 p-2 bg-light rounded") do
          content_tag(:small, class: "text-muted") do
            content_tag(:strong, "Context: ") + workout_log.context_for_display
          end
        end
      else
        "".html_safe
      end

      # Existing exercise details
      exercises_html = workout_log.exercises_hash.map do |exercise_name, sets|
        content_tag(:div, class: "mb-2") do
          content_tag(:strong, exercise_name) +
          content_tag(:ul) do
            sets.map { |set| content_tag(:li, set.description) }.join.html_safe
          end
        end
      end.join.html_safe

      context_html + exercises_html
    end
  end

  def render_benchmark_details(workout)
    benchmark_log = workout.benchmark_log
    return content_tag(:em, "No benchmark set") unless benchmark_log

    render_log_details(benchmark_log)
  end

  # 🆕 NEW: Render context summary for compact displays (like cards)
  def render_context_summary(workout_log, limit: 50)
    return nil unless workout_log.has_context?

    content_tag(:div, class: "context-summary text-muted small mt-1") do
      content_tag(:i, "", class: "bi bi-chat-square-text me-1") +
      content_tag(:span, workout_log.context_summary(limit: limit))
    end
  end

  # 🆕 NEW: Render full context display for detailed views
  def render_context_detail(workout_log)
    return nil unless workout_log.has_context?

    content_tag(:div, class: "context-detail border-start border-3 border-info ps-3 mb-3") do
      content_tag(:h6, class: "text-muted mb-1") do
        content_tag(:i, "", class: "bi bi-chat-square-text me-2") + "Exercise Context"
      end +
      content_tag(:p, workout_log.context_for_display, class: "mb-0 text-muted")
    end
  end

  # 🆕 Parse set description into structured badges
  def parse_set_into_badges(exercise_set)
    if AppConstants.cardio_exercise?(exercise_set.exercise_name)
    # Cardio badges - just time and energy
    [
      { type: 'time', content: exercise_set.duration_seconds ? "#{exercise_set.duration_seconds / 60} minutes" : "30 minutes" },
      { type: 'energy', content: exercise_set.energy_calories ? "#{exercise_set.energy_calories} calories" : "100 calories" }
    ]
    else
      # Existing strength badges
      [
        { type: 'status', content: "#{exercise_set.set_type.titleize} set" },
        { type: 'reps', content: exercise_set.reps ? "#{exercise_set.reps} reps" : "to failure" },
        { type: 'weight', content: exercise_set.weight_display },
        { type: 'reflection', content: exercise_set.notes || "solid effort" }
      ]
    end
  end

  # 🆕 Convert badge data to ExerciseSet attributes
  def badges_to_exercise_set_attrs(badges_array, exercise_name, set_number)
    status_badge = badges_array.find { |b| b[:type] == 'status' }
    reps_badge = badges_array.find { |b| b[:type] == 'reps' }
    weight_badge = badges_array.find { |b| b[:type] == 'weight' }
    reflection_badge = badges_array.find { |b| b[:type] == 'reflection' }

    # Parse set type from status badge
    set_type = extract_set_type(status_badge&.dig(:content))

    # Parse reps
    reps = extract_reps(reps_badge&.dig(:content))

    # Parse weight
    weight_data = extract_weight(weight_badge&.dig(:content))

    {
      exercise_name: exercise_name,
      set_number: set_number,
      set_type: set_type,
      reps: reps,
      weight_kg: weight_data[:weight],
      weight_unit: weight_data[:unit],
      notes: reflection_badge&.dig(:content) || "solid effort"
    }
  end

  # 🆕 Generate consistent default badges for new sets
  def generate_sample_badges(set_number = 1)
    [
      { type: 'status', content: 'Working set' },
      { type: 'reps', content: '1 reps' },
      { type: 'weight', content: 'at 1 kg' },
      { type: 'reflection', content: 'solid effort' }
    ]
  end

  # 🆕 NEW: Check if workout log has meaningful content for display
  def workout_log_has_content?(workout_log)
    workout_log.has_exercise_data? || workout_log.has_context?
  end

  # 🚀 FIXED: Generate workout summary using optimized methods to prevent N+1
  def workout_summary(workout_log)
    summary_parts = []

    # 🚀 FIXED: Use optimized method that checks for preloaded data
    if workout_log.has_exercise_data?
      # Use preloaded data if available, otherwise fall back to optimized count
      if workout_log.association(:exercise_sets).loaded?
        exercise_count = workout_log.exercises_hash.keys.count
        set_count = workout_log.exercise_sets.size
      else
        # This will still trigger queries, but it's a fallback
        exercise_count = workout_log.exercises_hash.keys.count
        set_count = workout_log.exercise_sets_count
      end

      summary_parts << "#{pluralize(exercise_count, 'exercise')}, #{pluralize(set_count, 'set')}"
    end

    # Context indicator
    if workout_log.has_context?
      summary_parts << "with context notes"
    end

    # Benchmark indicator
    if workout_log.is_benchmark?
      summary_parts << "(benchmark)"
    end

    summary_parts.any? ? summary_parts.join(" ") : "No details recorded"
  end

  # 🆕 NEW: Render workout log with proper context and exercise display
  def render_complete_workout_log(workout_log)
    return content_tag(:em, "Empty workout log") unless workout_log_has_content?(workout_log)

    content_tag(:div, class: "workout-log-display") do
      html = "".html_safe

      # Context section (if present)
      if workout_log.has_context?
        html += render_context_detail(workout_log)
      end

      # Exercise sets (if present)
      if workout_log.has_exercise_data?
        html += content_tag(:div, class: "exercises-section") do
          workout_log.exercises_hash.map do |exercise_name, sets|
            content_tag(:div, class: "exercise-group mb-3") do
              content_tag(:h6, exercise_name, class: "exercise-name text-primary mb-2") +
              content_tag(:div, class: "sets-list") do
                sets.map.with_index do |exercise_set, index|
                  content_tag(:div, class: "set-item small text-muted mb-1") do
                    "Set #{index + 1}: #{exercise_set.description}"
                  end
                end.join.html_safe
              end
            end
          end.join.html_safe
        end
      end

      html
    end
  end

  private

  def extract_set_type(status_content)
    return 'working' unless status_content.present?

    case status_content.downcase
    when /working/ then 'working'
    when /warmup/ then 'warmup'
    when /drop/ then 'drop'
    when /super/ then 'super'
    when /heavy/ then 'heavy'
    when /light/ then 'light'
    else 'working'
    end
  end

  def extract_reps(reps_content)
    return nil unless reps_content.present?
    return nil if reps_content.downcase.include?('failure')

    # Extract number from "12 reps" or just "12"
    match = reps_content.match(/(\d+)/)
    match ? match[1].to_i : nil
  end

  def extract_weight(weight_content)
    return { weight: nil, unit: 'kg' } unless weight_content.present?
    return { weight: nil, unit: 'kg' } if weight_content.downcase.include?('bodyweight')

    # Extract from "at 75 kg" or "75 kg" or "75"
    match = weight_content.match(/(\d+(?:\.\d+)?)\s*(kg|kilos?|lbs?|pounds?)?/i)

    if match
      weight = match[1].to_f
      unit = case match[2]&.downcase
             when /lb|pound/ then 'lbs'
             else 'kg'
             end
      { weight: weight, unit: unit }
    else
      { weight: nil, unit: 'kg' }
    end
  end
end
