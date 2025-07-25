class ClientAssignmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_trainer!

  def create
    @personal_trainer = current_user.personal_trainer
    name = params[:name]
    email = params[:email]

    user = User.new(name: name, email: email)
    temp_password = user.generate_temporary_password!

    if user.save
      @personal_trainer.client_assignments.create!(user: user)
      ClientMailer.welcome(user, temp_password, @personal_trainer).deliver_now

      redirect_to personal_trainer_path(@personal_trainer),
                  notice: "Client #{name} created! An invitation and temporary password has been sent to #{email}"
    else
      redirect_to personal_trainer_path(@personal_trainer),
                  alert: "Failed to create client: #{user.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @assignment = current_user.personal_trainer.client_assignments.find(params[:id])
    client_name = @assignment.user.name
    @assignment.destroy

    redirect_to personal_trainer_path(current_user.personal_trainer),
                notice: "#{client_name} removed."
  end

  private

  def ensure_trainer!
    unless current_user.trainer?
      redirect_to dashboard_path, alert: "Access denied."
    end
  end
end
