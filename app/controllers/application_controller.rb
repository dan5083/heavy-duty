class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_user_context, if: :user_signed_in?
  before_action :check_impersonation_timeout, if: :user_signed_in?

  private

  # NEW: Replace viewing_user with user_context
  def user_context
    @user_context
  end

  # NEW: Set up user context for every request
  def set_user_context
    @user_context = UserContext.new(current_user, session)
  end

  # NEW: Check if impersonation session has expired
  def check_impersonation_timeout
    return unless session[:impersonating_user_id]
    return unless session[:impersonation_started_at]

    started_at = Time.parse(session[:impersonation_started_at])
    timeout_duration = Rails.env.production? ? 2.hours : 8.hours

    if Time.current - started_at > timeout_duration
      # Log the timeout event
      log_audit_action(
        action: 'impersonation_timeout',
        metadata: {
          timeout_duration: timeout_duration.to_i,
          session_duration: (Time.current - started_at).to_i
        }
      )

      clear_impersonation_session
      redirect_to dashboard_path,
                  alert: "Impersonation session expired for security. Please switch clients again if needed."
    end
  rescue StandardError => e
    Rails.logger.warn "Failed to parse impersonation timestamp: #{e.message}"
    clear_impersonation_session
  end

  # NEW: Clear impersonation session safely
  def clear_impersonation_session
    session.delete(:impersonating_user_id)
    session.delete(:impersonation_started_at)
    Rails.logger.info "Cleared impersonation session for user #{current_user.id}"
  end

  # NEW: Ensure user can act on behalf of current acting user
  def ensure_can_act_on_behalf!
    unless user_context.can_act_on_behalf?
      # Log unauthorized access attempt
      log_audit_action(
        action: 'unauthorized_access_attempt',
        metadata: {
          attempted_subject_id: session[:impersonating_user_id],
          reason: 'permission_denied'
        }
      )

      clear_impersonation_session
      redirect_to dashboard_path, alert: "Access denied."
    end
  end

  # NEW: Helper method to log audit actions
  def log_audit_action(action:, resource: nil, metadata: {})
    return unless user_signed_in?

    # Add request metadata
    audit_metadata = metadata.merge(
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      request_path: request.path,
      request_method: request.method
    )

    AuditLog.log_action(
      performer: current_user,
      subject: user_context&.acting_user || current_user,
      action: action,
      resource: resource,
      metadata: audit_metadata
    )
  end

  # NEW: Helper method for views
  helper_method :user_context
end
