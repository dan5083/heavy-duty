# app/controllers/personal_trainers_controller.rb
class PersonalTrainersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_trainer!

  def show
    @personal_trainer = current_user.personal_trainer

    # 🚀 OPTIMIZED: Single query with comprehensive preloading
    @clients = @personal_trainer.clients
                               .includes(:split_plans, :workout_logs)
                               .order(:email)

    # 🚀 OPTIMIZED: Get unassigned users more efficiently
    @unassigned_users = User.left_joins(:client_assignments)
                           .where(client_assignments: { id: nil })
                           .where.not(id: current_user.id)
                           .where.not(id: PersonalTrainer.select(:user_id))  # Exclude other trainers
                           .order(:email)
                           .limit(20)  # Limit to prevent huge queries
  end

  private

  def ensure_trainer!
    unless current_user.trainer?
      redirect_to dashboard_path, alert: "Access denied."
    end
  end
end
