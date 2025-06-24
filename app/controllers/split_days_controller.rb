class SplitDaysController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_can_view_user!, if: -> { params[:client_id] }

  def edit
    @split_day = SplitDay.find(params[:id])
    @available_exercises = AppConstants::WORKOUTS[@split_day.muscle_group.to_sym]
    @selected = @split_day.workouts.pluck(:name)
  end

  def update
    @split_day = SplitDay.find(params[:id])
    selected_names = params[:workout_names] || []

    @split_day.workouts.destroy_all
    selected_names.each do |name|
      @split_day.workouts.create!(
        name: name,
        muscle_group: @split_day.muscle_group
      )
    end

    redirect_to split_plan_path(@split_day.split_plan), notice: "Exercises updated."
  end
end
