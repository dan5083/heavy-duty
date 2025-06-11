class UsersController < ApplicationController
  def show
    # Redirect away from Devise logout attempts accidentally routed here
    if params[:id] == "sign_out"
      redirect_to root_path, alert: "You have been signed out."
      return
    end

    @user = User.find(params[:id])
    @logs = @user.workout_logs.includes(:workout)
    @recovery = MuscleRecoveryStatus.new(workout_logs: @logs)
    @ready_muscles = @recovery.days_map.select { |_muscle, days| days <= 0 }.keys
  end
end
