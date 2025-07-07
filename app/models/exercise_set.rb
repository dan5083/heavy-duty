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
    "#{weight_kg} #{weight_unit}"
  end

  def to_badge_format
    if AppConstants.cardio_exercise?(exercise_name)
      # Cardio badges - just time and energy
      [
        { type: 'time', content: duration_seconds ? "#{duration_seconds / 60} minutes" : "30 minutes" },
        { type: 'energy', content: energy_calories ? "#{energy_calories} calories" : "100 calories" }
      ]
    else
      # Existing strength badges
      [
        { type: 'status', content: "#{set_type.titleize} set" },
        { type: 'reps', content: reps ? "#{reps} reps" : "to failure" },
        { type: 'weight', content: weight_display },
        { type: 'reflection', content: notes || "solid effort" }
      ]
    end
  end

  def energy_display
    return nil unless energy_calories
    "#{energy_calories} calories"
  end

  def description
    if AppConstants.cardio_exercise?(exercise_name)
      "#{duration_seconds ? "#{duration_seconds / 60} minutes" : "30 minutes"}, #{energy_calories ? "#{energy_calories} calories" : "100 calories"}"
    else
      "#{set_type.titleize} set, #{reps || 'failure'} reps, #{weight_display}, #{notes || 'solid effort'}"
    end
  end
end
