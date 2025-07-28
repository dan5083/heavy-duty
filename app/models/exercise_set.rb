class ExerciseSet < ApplicationRecord
  belongs_to :workout_log

  validates :exercise_name, presence: true
  validates :set_number, presence: true, numericality: { greater_than: 0 }
  validates :set_type, inclusion: { in: %w[working warmup drop super heavy light] }
  validates :reps, numericality: { greater_than: 0 }, allow_nil: true
  validates :weight_kg, numericality: { greater_than: 0 }, allow_nil: true

  scope :for_exercise, ->(name) { where(exercise_name: name) }
  scope :by_set_number, -> { order(:set_number) }

  def weight_display
    return "bodyweight" if weight_kg.nil?
    "#{weight_kg} kg"  # Always kg
  end

  def resistance_display
    return "no resistance" if weight_kg.nil?
    "#{weight_kg} kg"  # Same field, cardio context
  end

  def distance_display
    return "unknown distance" if distance_value.nil?
    "#{distance_value.to_i} m"
  end

  def duration_display
    return "unknown time" if duration_seconds.nil?
    minutes = duration_seconds / 60
    if minutes >= 60
      hours = minutes / 60
      remaining_minutes = minutes % 60
      "#{hours}h #{remaining_minutes}m"
    else
      "#{minutes} minutes"
    end
  end

  def energy_display
    return "unknown calories" if energy_calories.nil?
    "#{energy_calories} calories"
  end

  def to_badge_format
    if AppConstants.cardio_exercise?(exercise_name)
      # Cardio badges - time, distance, resistance (weight), energy
      [
        { type: 'time', content: duration_display },
        { type: 'distance', content: distance_display },
        { type: 'weight', content: resistance_display },  # weight_kg shown as resistance
        { type: 'energy', content: energy_display }
      ]
    else
      # Strength badges - status, reps, weight, reflection
      [
        { type: 'status', content: "#{set_type.titleize} set" },
        { type: 'reps', content: reps ? "#{reps} reps" : "to failure" },
        { type: 'weight', content: weight_display },
        { type: 'reflection', content: notes || "solid effort" }
      ]
    end
  end

  def description
    if AppConstants.cardio_exercise?(exercise_name)
      "#{duration_display}, #{distance_display}, #{resistance_display}, #{energy_display}"
    else
      "#{set_type.titleize} set, #{reps || 'failure'} reps, #{weight_display}, #{notes || 'solid effort'}"
    end
  end
end
