module WorkoutsHelper
  def render_log_details(details)
    parsed = parse_workout_details(details)

    return simple_format(details) unless parsed.is_a?(Hash)

    content_tag(:div) do
      parsed.map do |exercise, sets|
        content_tag(:div, class: "mb-2") do
          content_tag(:strong, exercise) +
          content_tag(:ul) do
            sets.map { |set| content_tag(:li, set) }.join.html_safe
          end
        end
      end.join.html_safe
    end
  end

  def render_benchmark_details(details)
    parsed = parse_workout_details(details)

    return simple_format(details) unless parsed.is_a?(Hash)

    content_tag(:div) do
      parsed.map do |exercise, sets|
        content_tag(:div, class: "mb-2") do
          content_tag(:strong, exercise) +
          content_tag(:ul) do
            sets.map { |set| content_tag(:li, set) }.join.html_safe
          end
        end
      end.join.html_safe
    end
  end

  def parse_workout_details(details)
    JSON.parse(details).yield_self do |parsed|
      if parsed.is_a?(Array) && parsed.first.is_a?(Hash)
        parsed.to_h { |entry| [entry["exercise"], entry["sets"]] }
      elsif parsed.is_a?(Hash)
        parsed
      else
        nil
      end
    end
  rescue JSON::ParserError
    nil
  end
end
