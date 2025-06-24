# app/controllers/dashboard_controller.rb

class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_can_act_on_behalf!

  def index
    # NEW: Show client switcher for trainers
    if current_user.trainer?
      @clients = user_context.available_clients.includes(:split_plans)
      @viewing_client = user_context.acting_user unless user_context.acting_user == current_user
    end

    # Use acting_user instead of viewing_user
    latest_plan = user_context.acting_user.split_plans.last
    unless latest_plan
      return redirect_to new_split_plan_path, alert: "Please create a split plan first."
    end

    @workouts_by_muscle = latest_plan
      .split_days
      .includes(:workouts)
      .flat_map(&:workouts)
      .group_by { |w| w.muscle_group.to_sym }
      .transform_values(&:first)

    # Use acting_user for recovery tracking
    recovery = RecoveryTracker.new(user_context.acting_user)
    all_data = recovery.full_map

    muscles = latest_plan.split_days.pluck(:muscle_group).map(&:to_sym).uniq
    filtered_data = all_data.slice(*muscles)

    @readiness_data = filtered_data.sort_by do |muscle, data|
      if data[:days_left] <= 0
        [0, -data[:days_ready], muscle.to_s]
      else
        [1, data[:days_left], muscle.to_s]
      end
    end.to_h

    longest_ready = @readiness_data.find { |_, data| data[:days_left] <= 0 && data[:days_ready] > 0 }
    if longest_ready
      muscle, data = longest_ready
      @next_ready = {
        muscle: muscle,
        label: data[:label],
        ready_on: data[:ready_on],
        days_ready: data[:days_ready]
      }
    end
  end
end
