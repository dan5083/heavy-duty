class PersonalTrainersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_trainer!

  def show
    @personal_trainer = current_user.personal_trainer
    @clients = @personal_trainer.clients.includes(:split_plans, :workout_logs)
    @unassigned_users = User.left_joins(:client_assignments)
                           .where(client_assignments: { id: nil })
                           .where.not(id: current_user.id)
  end

  private

  def ensure_trainer!
    unless current_user.trainer?
      redirect_to dashboard_path, alert: "Access denied."
    end
  end
end
