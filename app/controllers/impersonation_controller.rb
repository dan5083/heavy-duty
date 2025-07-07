# app/controllers/impersonation_controller.rb

class ImpersonationController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_trainer!
  before_action :set_target_user, only: [:start]

  def start
    if current_user.personal_trainer.clients.include?(@target_user)
      session[:impersonating_user_id] = @target_user.id
      session[:impersonation_started_at] = Time.current.iso8601

      # Log impersonation start
      log_audit_action(
        action: 'start_impersonation',
        subject: @target_user,
        metadata: {
          session_started_at: session[:impersonation_started_at],
          client_count: current_user.personal_trainer.clients.count
        }
      )

      redirect_to dashboard_path, notice: "Now acting as #{@target_user.email}"
    else
      # Log unauthorized impersonation attempt
      log_audit_action(
        action: 'unauthorized_impersonation_attempt',
        subject: @target_user,
        metadata: {
          reason: 'not_a_client',
          target_user_id: @target_user.id
        }
      )

      redirect_to dashboard_path, alert: "Access denied."
    end
  end

  def stop
    if session[:impersonating_user_id]
      impersonated_user = User.find_by(id: session[:impersonating_user_id])
      impersonated_email = impersonated_user&.email || "unknown user"

      # Calculate session duration safely
      session_duration = nil
      if session[:impersonation_started_at]
        begin
          started_at = Time.parse(session[:impersonation_started_at])
          session_duration = (Time.current - started_at).to_i
        rescue StandardError
          # Continue without duration if parsing fails
        end
      end

      # Log impersonation stop
      if impersonated_user
        log_audit_action(
          action: 'stop_impersonation',
          subject: impersonated_user,
          metadata: {
            session_duration_seconds: session_duration,
            stopped_manually: true
          }
        )
      end

      clear_impersonation_session

      redirect_to dashboard_path, notice: "Stopped acting as #{impersonated_email}"
    else
      redirect_to dashboard_path
    end
  end

  private

  def ensure_trainer!
    unless current_user.trainer?
      redirect_to dashboard_path, alert: "Access denied."
    end
  end

  def set_target_user
    @target_user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_path, alert: "User not found."
  end

  # Use the centralized method from ApplicationController
  def log_audit_action(action:, subject: nil, metadata: {})
    super(
      action: action,
      resource: subject,
      metadata: metadata.merge(
        performer_email: current_user.email,
        subject_email: subject&.email
      )
    )
  end
end
