# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_user_context, if: :user_signed_in?
  before_action :check_impersonation_timeout, if: :user_signed_in?
  before_action :preload_trainer_clients, if: :user_signed_in? # 🆕 NEW

  # PUBLIC: Helper method for views - must be above private
  def user_context
    @user_context
  end

  # 🆕 NEW: Make preloaded clients available in views
  def preloaded_clients
    @preloaded_clients
  end

  # Make user_context and preloaded_clients available in views
  helper_method :user_context, :preloaded_clients

  private

  def set_user_context
    @user_context = UserContext.new(current_user, session)
  end

  # 🆕 NEW: Preload trainer clients to prevent N+1 in navbar
  def preload_trainer_clients
    # Skip preloading for controllers that don't need client data
    return if params[:controller] == 'pwa'
    return unless current_user&.trainer?

    # Single query to get all client data needed for navbar
    @preloaded_clients = current_user.personal_trainer
                                   .clients
                                   .includes(:split_plans)
                                   .to_a # Force execution here

    # Cache the count to avoid repeated COUNT queries
    @client_count = @preloaded_clients.size
  end

  # 🆕 NEW: Helper for client count
  def client_count
    @client_count || 0
  end
  helper_method :client_count

  # CENTRALIZED: Single place for session timeout checking and clearing
  def check_impersonation_timeout
    return unless @user_context.impersonation_mode?
    return if @user_context.session_valid?

    # Session is invalid/expired - clear it and redirect
    log_audit_action(
      action: 'impersonation_timeout',
      metadata: {
        timeout_reason: 'session_expired_or_invalid',
        controller: params[:controller],
        action: params[:action]
      }
    )

    clear_impersonation_session
    redirect_to dashboard_path,
                alert: "Impersonation session expired for security. Please switch clients again if needed."
  end

  def clear_impersonation_session
    session.delete(:impersonating_user_id)
    session.delete(:impersonation_started_at)
  end

  def ensure_can_act_on_behalf!
    unless user_context.can_act_on_behalf?
      # Log unauthorized access attempt
      log_audit_action(
        action: 'unauthorized_access_attempt',
        metadata: {
          attempted_subject_id: session[:impersonating_user_id],
          reason: 'permission_denied',
          controller: params[:controller],
          action: params[:action]
        }
      )

      clear_impersonation_session
      redirect_to dashboard_path, alert: "Access denied."
    end
  end

  def log_audit_action(action:, resource: nil, metadata: {})
    return unless user_signed_in?

    # Add essential request metadata only
    audit_metadata = metadata.merge(
      ip_address: request.remote_ip,
      request_path: request.path,
      timestamp: Time.current.iso8601
    )

    AuditLog.log_action(
      performer: current_user,
      subject: user_context&.acting_user || current_user,
      action: action,
      resource: resource,
      metadata: audit_metadata
    )
  end
end
