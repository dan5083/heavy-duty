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

  # 🆕 UPDATED: Parse set description into structured badges - Uses workout context
  def parse_set_into_badges(exercise_set)
    # 🆕 NEW: Determine cardio context from workout instead of exercise name
    workout = exercise_set.workout_log.workout
    is_cardio_workout = AppConstants.cardio_workout?(workout.muscle_group)

    if is_cardio_workout
      # Cardio badges - time, distance, weight (as resistance), energy
      [
        { type: 'time', content: exercise_set.duration_display },
        { type: 'distance', content: exercise_set.distance_display },
        { type: 'weight', content: exercise_set.resistance_display },  # weight_kg shown as resistance
        { type: 'energy', content: exercise_set.energy_display }
      ]
    else
      # Strength badges - status, reps, weight, reflection
      [
        { type: 'status', content: "#{exercise_set.set_type.titleize} set" },
        { type: 'reps', content: exercise_set.reps ? "#{exercise_set.reps} reps" : "to failure" },
        { type: 'weight', content: exercise_set.weight_display },
        { type: 'reflection', content: exercise_set.notes || "solid effort" }
      ]
    end
  end

  # 🆕 UPDATED: Convert badge data to ExerciseSet attributes - Uses workout context if available
  def badges_to_exercise_set_attrs(badges_array, exercise_name, set_number, workout_context = nil)
    status_badge = badges_array.find { |b| b[:type] == 'status' }
    reflection_badge = badges_array.find { |b| b[:type] == 'reflection' }

    # Base attributes
    attrs = {
      exercise_name: exercise_name,
      set_number: set_number,
      set_type: extract_set_type(status_badge&.dig(:content)) || 'working',
      notes: reflection_badge&.dig(:content) || "solid effort"
    }

    # 🆕 NEW: Use workout context if provided, otherwise fall back to exercise name inference
    is_cardio = if workout_context
      AppConstants.cardio_workout?(workout_context)
    else
      # Fallback: check if exercise name is in cardio list (for backward compatibility)
      AppConstants.cardio_exercises.include?(exercise_name)
    end

    if is_cardio
      # Cardio fields - time, distance, weight (resistance), energy
      time_badge = badges_array.find { |b| b[:type] == 'time' }
      distance_badge = badges_array.find { |b| b[:type] == 'distance' }
      weight_badge = badges_array.find { |b| b[:type] == 'weight' }
      energy_badge = badges_array.find { |b| b[:type] == 'energy' }

      attrs.merge!({
        duration_seconds: extract_duration(time_badge&.dig(:content)),
        distance_value: extract_distance(distance_badge&.dig(:content)),
        weight_kg: extract_weight(weight_badge&.dig(:content))[:weight],
        energy_calories: extract_calories(energy_badge&.dig(:content))
      })
    else
      # Strength fields
      reps_badge = badges_array.find { |b| b[:type] == 'reps' }
      weight_badge = badges_array.find { |b| b[:type] == 'weight' }

      attrs.merge!({
        reps: extract_reps(reps_badge&.dig(:content)),
        weight_kg: extract_weight(weight_badge&.dig(:content))[:weight]
      })
    end

    attrs
  end

  # 🆕 NEW: Extract duration from time badge (converts minutes to seconds)
  def extract_duration(time_content)
    return nil unless time_content.present?
    return nil if time_content.downcase.include?('unknown')

    # Extract from "30 minutes", "1 minute"
    match = time_content.match(/(\d+)\s*minute/)
    return match ? match[1].to_i * 60 : nil  # Convert to seconds
  end

  # 🆕 NEW: Extract distance from distance badge - METERS ONLY
  def extract_distance(distance_content)
    return nil unless distance_content.present?
    return nil if distance_content.downcase.include?('unknown')

    # Extract from "100 m", "50 m" etc.
    match = distance_content.match(/(\d+)\s*m/)
    return match ? match[1].to_i : nil
  end

  # 🆕 NEW: Extract calories from energy badge
  def extract_calories(energy_content)
    return nil unless energy_content.present?
    return nil if energy_content.downcase.include?('unknown')

    # Extract from "100 calories"
    match = energy_content.match(/(\d+)\s*calorie/)
    return match ? match[1].to_i : nil
  end

  # 🆕 Generate consistent default badges for new sets
  def generate_sample_badges(set_number = 1)
    [
      { type: 'status', content: 'Working set' },
      { type: 'reps', content: '1 reps' },
      { type: 'weight', content: '1 kg' },  # Always kg
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

  # UPDATED: Remove lbs conversion - KG ONLY
  def extract_weight(weight_content)
    return { weight: nil } unless weight_content.present?
    return { weight: nil } if weight_content.downcase.include?('bodyweight') ||
                              weight_content.downcase.include?('no resistance') ||
                              weight_content.downcase.include?('unknown')

    # Extract from "75 kg" or just "75"
    match = weight_content.match(/(\d+(?:\.\d+)?)\s*kg?/i)

    if match
      weight = match[1].to_f
      { weight: weight }
    else
      { weight: nil }
    end
  end
end
