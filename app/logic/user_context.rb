# app/logic/user_context.rb
class UserContext
  attr_reader :current_user, :acting_user

  def initialize(current_user, session)
    @current_user = current_user
    @session = session
    @acting_user = determine_acting_user
  end

  def impersonation_mode?
    acting_user != current_user
  end

  def can_impersonate?(target_user)
    return false unless current_user&.trainer?
    return false unless target_user
    current_user.personal_trainer.clients.include?(target_user)
  end

  def available_clients
    return [] unless current_user&.trainer?
    current_user.personal_trainer.clients
  end

  def can_act_on_behalf?
    impersonation_mode? ? can_impersonate?(acting_user) : true
  end

  def session_valid?
    return true unless impersonation_mode?
    return false unless @session[:impersonation_started_at]

    begin
      started_at = Time.parse(@session[:impersonation_started_at])
      timeout_duration = Rails.env.production? ? 2.hours : 8.hours
      Time.current - started_at <= timeout_duration
    rescue StandardError
      false
    end
  end

  def session_info
    return nil unless impersonation_mode?
    return nil unless @session[:impersonation_started_at]

    begin
      started_at = Time.parse(@session[:impersonation_started_at])
      duration = Time.current - started_at
      timeout_duration = Rails.env.production? ? 2.hours : 8.hours

      {
        started_at: started_at,
        duration: duration,
        remaining: timeout_duration - duration,
        expired?: duration > timeout_duration
      }
    rescue StandardError
      nil
    end
  end

  private

  def determine_acting_user
    # No impersonation session = current user
    return current_user unless @session[:impersonating_user_id]

    # Session expired = current user (don't clear here, let controller handle it)
    return current_user unless session_valid?

    # Find target user
    target_user = User.find_by(id: @session[:impersonating_user_id])
    return current_user unless target_user

    # Check authorization (don't clear session here, just return current_user if invalid)
    return current_user unless can_impersonate?(target_user)

    target_user
  end
end
