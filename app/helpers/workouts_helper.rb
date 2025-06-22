module WorkoutsHelper
  def render_log_details(workout_log)
    return content_tag(:em, "No exercises recorded") if workout_log.exercise_sets.empty?

    content_tag(:div) do
      workout_log.exercises_hash.map do |exercise_name, sets|
        content_tag(:div, class: "mb-2") do
          content_tag(:strong, exercise_name) +
          content_tag(:ul) do
            sets.map { |set| content_tag(:li, set.description) }.join.html_safe
          end
        end
      end.join.html_safe
    end
  end

  def render_benchmark_details(workout)
    benchmark_log = workout.benchmark_log
    return content_tag(:em, "No benchmark set") unless benchmark_log

    render_log_details(benchmark_log)
  end

  # 🆕 Parse set description into structured badges
  def parse_set_into_badges(exercise_set)
    [
      { type: 'status', content: "#{exercise_set.set_type.titleize} set" },
      { type: 'reps', content: exercise_set.reps ? "#{exercise_set.reps} reps" : "to failure" },
      { type: 'weight', content: exercise_set.weight_display },
      { type: 'reflection', content: exercise_set.notes || "solid effort" }
    ]
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
