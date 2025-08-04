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

  # 🆕 UPDATED: Use workout context to determine badge format instead of exercise name
  def to_badge_format
    # 🆕 NEW: Get cardio context from workout instead of exercise name
    is_cardio_workout = workout_log.workout.muscle_group == 'cardio'

    if is_cardio_workout
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

  # 🆕 UPDATED: Use workout context for description instead of exercise name
  def description
    # 🆕 NEW: Get cardio context from workout instead of exercise name
    is_cardio_workout = workout_log.workout.muscle_group == 'cardio'

    if is_cardio_workout
      "#{duration_display}, #{distance_display}, #{resistance_display}, #{energy_display}"
    else
      "#{set_type.titleize} set, #{reps || 'failure'} reps, #{weight_display}, #{notes || 'solid effort'}"
    end
  end

  # 🆕 NEW: Helper method to check if this set belongs to a cardio workout
  def cardio_workout?
    workout_log.workout.muscle_group == 'cardio'
  end

  # 🆕 NEW: Helper method to check if this set belongs to a lifting workout
  def lifting_workout?
    !cardio_workout?
  end

  # 🆕 NEW: Get workout context for use in helpers and other methods
  def workout_context
    workout_log.workout.muscle_group
  end

  # 🆕 NEW: Validation helper - ensure cardio fields are only set for cardio workouts
  def validate_fields_match_workout_type
    if cardio_workout?
      # Cardio workouts should not have reps (they can have resistance/weight though)
      if reps.present?
        errors.add(:reps, "should not be set for cardio workouts")
      end
    else
      # Lifting workouts should not have cardio-specific fields
      if duration_seconds.present?
        errors.add(:duration_seconds, "should not be set for lifting workouts")
      end
      if distance_value.present?
        errors.add(:distance_value, "should not be set for lifting workouts")
      end
      if energy_calories.present?
        errors.add(:energy_calories, "should not be set for lifting workouts")
      end
    end
  end

  # 🆕 NEW: Smart display method that shows relevant fields based on workout type
  def smart_display
    if cardio_workout?
      parts = []
      parts << duration_display if duration_seconds.present?
      parts << distance_display if distance_value.present?
      parts << resistance_display if weight_kg.present?
      parts << energy_display if energy_calories.present?
      parts.join(", ")
    else
      parts = []
      parts << "#{set_type.titleize} set" if set_type.present?
      parts << (reps ? "#{reps} reps" : "to failure")
      parts << weight_display if weight_kg.present?
      parts << notes if notes.present?
      parts.join(", ")
    end
  end

  # 🆕 NEW: Get the appropriate badge types for this exercise set
  def badge_types
    if cardio_workout?
      [:time, :distance, :weight, :energy]
    else
      [:status, :reps, :weight, :reflection]
    end
  end

  # 🆕 NEW: Check if this set has complete data for its workout type
  def complete_data?
    if cardio_workout?
      # For cardio, we expect at least duration or distance
      duration_seconds.present? || distance_value.present?
    else
      # For lifting, we expect at least reps (or failure) and optionally weight
      reps.present? || notes&.downcase&.include?('failure')
    end
  end

  # 🆕 NEW: Get missing fields for this workout type
  def missing_fields
    missing = []

    if cardio_workout?
      missing << :duration_seconds if duration_seconds.blank?
      missing << :distance_value if distance_value.blank?
      missing << :energy_calories if energy_calories.blank?
      # Weight is optional for cardio (bodyweight exercises)
    else
      missing << :reps if reps.blank? && !notes&.downcase&.include?('failure')
      missing << :weight_kg if weight_kg.blank?
      missing << :notes if notes.blank?
    end

    missing
  end

  # 🆕 NEW: Summary for logging and debugging
  def summary
    "#{exercise_name} - Set #{set_number}: #{smart_display}"
  end
end
