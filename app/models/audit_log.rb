# app/models/audit_log.rb

class AuditLog < ApplicationRecord
  belongs_to :performer, class_name: 'User'    # Who actually performed the action
  belongs_to :subject, class_name: 'User'      # Whose account was affected

  validates :action, presence: true
  validates :resource_type, presence: true

  # FIXED: Rails 8 serialize syntax
  serialize :metadata, coder: JSON

  # Scopes for common queries
  scope :impersonation_actions, -> { where.not(performer: subject) }
  scope :by_trainer, ->(trainer) { where(performer: trainer) }
  scope :by_client, ->(client) { where(subject: client) }
  scope :recent, -> { order(created_at: :desc) }
  scope :for_resource, ->(resource) { where(resource_type: resource.class.name, resource_id: resource.id) }

  # Class method to log actions
  def self.log_action(performer:, subject:, action:, resource: nil, metadata: {})
    create!(
      performer: performer,
      subject: subject,
      action: action.to_s,
      resource_type: resource&.class&.name,
      resource_id: resource&.id,
      metadata: metadata
    )
  rescue StandardError => e
    Rails.logger.error "Failed to create audit log: #{e.message}"
    # Don't let audit logging failures break the main action
    nil
  end

  # Instance methods
  def impersonation?
    performer != subject
  end

  def description
    if impersonation?
      "#{performer.email} (as #{subject.email}) #{action_description}"
    else
      "#{performer.email} #{action_description}"
    end
  end

  def resource_name
    return nil unless resource_type && resource_id
    "#{resource_type}##{resource_id}"
  end

  private

  def action_description
    case action
    when 'start_impersonation'
      'started impersonating'
    when 'stop_impersonation'
      'stopped impersonating'
    when 'create_workout_log'
      "created workout log#{resource_name ? " (#{resource_name})" : ""}"
    when 'create_split_plan'
      "created split plan#{resource_name ? " (#{resource_name})" : ""}"
    when 'delete_split_plan'
      "deleted split plan#{resource_name ? " (#{resource_name})" : ""}"
    else
      action.humanize.downcase
    end
  end
end
