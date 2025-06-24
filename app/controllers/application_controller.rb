class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  # NEW: Handle viewing as client context
  def viewing_user
    if params[:client_id] && current_user&.trainer?
      @viewing_user ||= current_user.personal_trainer.clients.find(params[:client_id])
    else
      @viewing_user ||= current_user
    end
  end

  def ensure_can_view_user!
    unless current_user.can_view_user?(viewing_user)
      redirect_to dashboard_path, alert: "Access denied."
    end
  end
end
