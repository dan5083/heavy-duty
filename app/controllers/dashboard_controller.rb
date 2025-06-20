class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    latest_plan = current_user.split_plans.last
    unless latest_plan
      return redirect_to new_split_plan_path, alert: "Please create a split plan first."
    end

    @workouts_by_muscle = latest_plan
      .split_days
      .includes(:workouts)
      .flat_map(&:workouts)
      .group_by { |w| w.muscle_group.to_sym }
      .transform_values(&:first)

    recovery = RecoveryTracker.new(current_user)
    all_data = recovery.full_map

    muscles = latest_plan.split_days.pluck(:muscle_group).map(&:to_sym).uniq
    filtered_data = all_data.slice(*muscles)

    @readiness_data = filtered_data.sort_by do |muscle, data|
      if data[:days_left] <= 0
        # Ready muscles: category 0 (first), sort by days_ready DESCENDING (longest wait first)
        [0, -data[:days_ready], muscle.to_s]
      else
        # Recovering muscles: category 1 (last), sort by days_left ascending
        [1, data[:days_left], muscle.to_s]
      end
    end.to_h

    # Determine LONGEST ready muscle (the one that's been waiting the most)
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
