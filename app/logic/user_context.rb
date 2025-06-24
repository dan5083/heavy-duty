class UserContext
  attr_reader :current_user, :acting_user

  def initialize(current_user, session)
    @current_user = current_user
    @acting_user = determine_acting_user(session)
  end

  # Check if we're in impersonation mode
  def impersonation_mode?
    acting_user != current_user
  end

  # Check if current user can impersonate target user
  def can_impersonate?(target_user)
    return false unless current_user&.trainer?
    return false unless target_user

    current_user.personal_trainer.clients.include?(target_user)
  end

  # Get list of users that current user can impersonate
  def available_clients
    return [] unless current_user&.trainer?

    current_user.personal_trainer.clients
  end

  # Check if current user can perform action on acting user's data
  def can_act_on_behalf?
    return true unless impersonation_mode?

    can_impersonate?(acting_user)
  end

  # NEW: Get impersonation session info
  def impersonation_info(session)
    return nil unless impersonation_mode?
    return nil unless session[:impersonation_started_at]

    started_at = Time.parse(session[:impersonation_started_at])
    duration = Time.current - started_at
    timeout_duration = Rails.env.production? ? 2.hours : 8.hours
    remaining = timeout_duration - duration

    {
      started_at: started_at,
      duration: duration,
      remaining: remaining,
      expired?: remaining <= 0
    }
  rescue StandardError
    nil
  end

  private

  def determine_acting_user(session)
    # If no impersonation session, acting user is current user
    return current_user unless session[:impersonating_user_id]

    # Check if session has expired
    if session_expired?(session)
      clear_invalid_session(session)
      return current_user
    end

    # Find the user we're trying to impersonate
    target_user = User.find_by(id: session[:impersonating_user_id])

    # If target user doesn't exist or we can't impersonate them,
    # fall back to current user
    if target_user && can_impersonate?(target_user)
      target_user
    else
      # Clear invalid session and fall back
      clear_invalid_session(session)
      current_user
    end
  end

  def session_expired?(session)
    return false unless session[:impersonation_started_at]

    started_at = Time.parse(session[:impersonation_started_at])
    timeout_duration = Rails.env.production? ? 2.hours : 8.hours

    Time.current - started_at > timeout_duration
  rescue StandardError
    true  # If we can't parse the timestamp, consider it expired
  end

  def clear_invalid_session(session)
    session.delete(:impersonating_user_id)
    session.delete(:impersonation_started_at)
  end
end
