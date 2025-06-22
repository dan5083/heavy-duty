class SplitPlan < ApplicationRecord
  belongs_to :user
  has_many :split_days, dependent: :destroy

  # 🆕 Validation for custom splits
  validate :custom_config_valid, if: :is_custom?
  validate :at_least_one_muscle_selected, if: :is_custom?

  # 🆕 Parse custom_config JSON safely
  def custom_config_parsed
    return {} unless is_custom? && custom_config.present?
    JSON.parse(custom_config)
  rescue JSON::ParserError
    {}
  end

  # 🆕 Check if this is a custom split
  def custom?
    is_custom?
  end

  # 🆕 Get the muscle groups for this split
  def muscle_groups
    if custom?
      custom_config_parsed.keys.map(&:to_sym)
    else
      AppConstants::SPLITS[name.to_sym] || []
    end
  end

  # 🆕 Get recovery days for a specific muscle
  def muscle_recovery_days(muscle)
    if custom?
      custom_config_parsed[muscle.to_s] || AppConstants.recovery_days_for(muscle)
    else
      AppConstants.recovery_days_for(muscle)
    end
  end

  # 🆕 Get all custom muscles with their recovery days
  def custom_muscles
    return {} unless custom?
    custom_config_parsed.transform_keys(&:to_sym).transform_values(&:to_i)
  end

  # 🆕 Set custom configuration
  def set_custom_config(muscles_and_recovery)
    self.custom_config = muscles_and_recovery.to_json
    self.is_custom = true
    self.name = "Custom Split"
    self.split_length = muscles_and_recovery.keys.length
  end

  private

  def custom_config_valid
    return unless is_custom?

    begin
      config = JSON.parse(custom_config)
      return if config.is_a?(Hash) && config.present?
    rescue JSON::ParserError
      # Fall through to error
    end

    errors.add(:custom_config, "must be valid JSON with muscle groups and recovery days")
  end

  def at_least_one_muscle_selected
    return unless is_custom?

    config = custom_config_parsed
    if config.empty?
      errors.add(:custom_config, "must include at least one muscle group")
    end
  end
end
