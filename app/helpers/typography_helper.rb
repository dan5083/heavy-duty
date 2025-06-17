# app/helpers/typography_helper.rb
module TypographyHelper
  # Helper methods to apply semantic typography classes

  def brand_text(text, options = {})
    css_class = "navbar-brand #{options[:class]}"
    content_tag(:span, text, class: css_class)
  end

  def display_heading(text, level = 1, options = {})
    css_class = "text-display weight-bold #{options[:class]}"
    content_tag("h#{level}".to_sym, text, class: css_class)
  end

  def exercise_name(text, options = {})
    css_class = "exercise-name #{options[:class]}"
    content_tag(:span, text, class: css_class)
  end

  def data_value(value, unit = nil, options = {})
    css_class = "data-text #{options[:class]}"
    html = content_tag(:span, value, class: "metric-value #{css_class}")
    if unit
      html += content_tag(:span, unit, class: "text-muted text-sm ms-1")
    end
    html.html_safe
  end

  def workout_badge(text, type = :default, options = {})
    type_class = case type
    when :status then "badge-status"
    when :reps then "badge-reps"
    when :weight then "badge-weight"
    when :note then "badge-reflection"
    else "badge-secondary"
    end

    css_class = "workout-badge #{type_class} #{options[:class]}"
    content_tag(:span, text, class: css_class)
  end

  def countdown_display(days, hours = nil, minutes = nil)
    html = ""

    if days && days > 0
      html += content_tag(:span, days, class: "countdown-number")
      html += content_tag(:span, "D", class: "countdown-unit")
    end

    if hours
      html += content_tag(:span, hours, class: "countdown-number ms-2")
      html += content_tag(:span, "H", class: "countdown-unit")
    end

    if minutes
      html += content_tag(:span, minutes, class: "countdown-number ms-2")
      html += content_tag(:span, "M", class: "countdown-unit")
    end

    html.html_safe
  end

  def set_number_display(number, options = {})
    css_class = "set-number text-mono weight-bold #{options[:class]}"
    content_tag(:span, "#{number}️⃣", class: css_class)
  end

  def metric_card_title(text, options = {})
    css_class = "card-title text-display #{options[:class]}"
    content_tag(:h5, text, class: css_class)
  end

  def body_text(text, size = :base, options = {})
    size_class = "text-#{size}"
    css_class = "#{size_class} #{options[:class]}"
    content_tag(:p, text, class: css_class)
  end
end
