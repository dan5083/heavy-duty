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

  # 🆕 Parse set description into structured badges
  def parse_set_into_badges(set_description)
    badges = []
    text = set_description.to_s.strip

    # Try to extract structured information using patterns
    badges += extract_status_badges(text)
    badges += extract_reps_badges(text)
    badges += extract_weight_badges(text)
    badges += extract_reflection_badges(text)

    # If no structured badges found, create a generic text badge
    if badges.empty?
      badges << { type: 'reflection', content: text }
    end

    badges
  end

  # 🆕 Convert badge data back to natural language text
  def badges_to_text(badges_array)
    return "" if badges_array.blank?

    # Group badges by type for natural sentence construction
    status = badges_array.find { |b| b[:type] == 'status' }&.dig(:content)
    reps = badges_array.find { |b| b[:type] == 'reps' }&.dig(:content)
    weight = badges_array.find { |b| b[:type] == 'weight' }&.dig(:content)
    reflection = badges_array.find { |b| b[:type] == 'reflection' }&.dig(:content)

    # Build natural sentence
    parts = []
    parts << status if status.present?
    parts << "was" if status.present? && !status.include?("was")
    parts << reps if reps.present?
    parts << weight if weight.present?
    parts << reflection if reflection.present?

    sentence = parts.join(" ")
    sentence.ends_with?(".") ? sentence : "#{sentence}."
  end

  # 🆕 Generate sample badges for new sets
  def generate_sample_badges(set_number = 1)
    status_options = AppConstants::CLAUSE_LIBRARY[:status]
    reps_options = ["8 reps", "10 reps", "12 reps", "to failure"]
    weight_options = ["at #{rand(40..100)} kilos", "with bodyweight"]
    reflection_options = AppConstants::CLAUSE_LIBRARY[:reflection]

    [
      { type: 'status', content: status_options.sample },
      { type: 'reps', content: reps_options.sample },
      { type: 'weight', content: weight_options.sample },
      { type: 'reflection', content: reflection_options.sample }
    ]
  end

  private

  def parse_workout_details(details)
    return nil if details.blank?

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

  # Extract status information (Working set, Drop set, etc.)
  def extract_status_badges(text)
    status_patterns = [
      /\b(working set|warmup set|drop set|super set|heavy set|light set|final set|first set|second set|third set)\b/i,
      /\b(working|warmup|drop|super|heavy|light|final)\s+set\b/i
    ]

    badges = []
    status_patterns.each do |pattern|
      if match = text.match(pattern)
        badges << { type: 'status', content: match[0].titleize }
        break
      end
    end
    badges
  end

  # Extract reps information (12 reps, to failure, etc.)
  def extract_reps_badges(text)
    reps_patterns = [
      /\b(\d+)\s+reps?\b/i,
      /\b(\d+-\d+)\s+reps?\b/i,
      /\bto failure\b/i,
      /\bAMRAP\b/i,
      /\bas many reps as possible\b/i
    ]

    badges = []
    reps_patterns.each do |pattern|
      if match = text.match(pattern)
        content = case match[0].downcase
                  when /to failure/
                    "to failure"
                  when /amrap/
                    "AMRAP"
                  when /as many reps/
                    "AMRAP"
                  else
                    "#{match[1]} reps"
                  end
        badges << { type: 'reps', content: content }
        break
      end
    end
    badges
  end

  # Extract weight information (at 75 kilos, with bodyweight, etc.)
  def extract_weight_badges(text)
    weight_patterns = [
      /\bat (\d+(?:\.\d+)?)\s*(kilos?|kgs?|lbs?|pounds?)\b/i,
      /\bwith (\d+(?:\.\d+)?)\s*(kilos?|kgs?|lbs?|pounds?)\b/i,
      /\b(\d+(?:\.\d+)?)\s*(kilos?|kgs?|lbs?|pounds?)\b/i,
      /\bwith bodyweight\b/i,
      /\bbodyweight\b/i,
      /\bat (\d+)%\s*1RM\b/i
    ]

    badges = []
    weight_patterns.each do |pattern|
      if match = text.match(pattern)
        content = case match[0].downcase
                  when /bodyweight/
                    "with bodyweight"
                  when /1rm/
                    "at #{match[1]}% 1RM"
                  when /at/
                    "at #{match[1]} #{match[2].downcase.gsub(/s$/, '')}"
                  else
                    "at #{match[1]} #{match[2]&.downcase&.gsub(/s$/, '') || 'kilos'}"
                  end
        badges << { type: 'weight', content: content }
        break
      end
    end
    badges
  end

  # Extract reflection/notes (felt heavy, perfect form, etc.)
  def extract_reflection_badges(text)
    reflection_patterns = [
      /\b(felt heavy|felt light|felt good|felt strong)\b/i,
      /\b(perfect form|good form|form broke down|sloppy form)\b/i,
      /\b(could go heavier|next time go heavier|too easy|too hard)\b/i,
      /\b(solid effort|great pump|burned|cramped)\b/i,
      /\b(kept it smooth|slow and controlled|explosive)\b/i
    ]

    badges = []
    reflection_patterns.each do |pattern|
      if match = text.match(pattern)
        badges << { type: 'reflection', content: match[0].downcase }
        break
      end
    end

    # If no specific reflection found but there's extra text, use it
    if badges.empty?
      # Remove already extracted parts and see if there's meaningful text left
      cleaned = text.gsub(/\b(working|warmup|drop|super|heavy|light|final|first|second|third)\s+set\b/i, '')
                    .gsub(/\b\d+\s+reps?\b/i, '')
                    .gsub(/\b(to failure|amrap)\b/i, '')
                    .gsub(/\bat \d+(?:\.\d+)?\s*(kilos?|kgs?|lbs?|pounds?)\b/i, '')
                    .gsub(/\bwith bodyweight\b/i, '')
                    .gsub(/\bwas\b/i, '')
                    .strip
                    .gsub(/^,|,$/, '')
                    .strip

      if cleaned.present? && cleaned.length > 3
        badges << { type: 'reflection', content: cleaned }
      end
    end

    badges
  end
end
