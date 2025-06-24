# app/controllers/training_archive_controller.rb

class TrainingArchiveController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_can_act_on_behalf!  # NEW

  def index
    # Get only muscle groups that the acting_user actually has workouts for
    # Changed from viewing_user to user_context.acting_user
    user_muscle_groups = user_context.acting_user.workout_logs
                                    .joins(:workout)
                                    .distinct
                                    .pluck('workouts.muscle_group')
                                    .map(&:to_sym)

    # Filter LABELS to only include muscle groups the user has (exclude split plan labels)
    @muscles = AppConstants::LABELS.select do |key, _label|
      user_muscle_groups.include?(key) && AppConstants::WORKOUTS.key?(key)
    end

    @selected_muscle = params[:muscle]

    # Use acting_user instead of viewing_user
    @logs = user_context.acting_user.workout_logs.includes(:workout).order(created_at: :desc)

    if @selected_muscle.present?
      @logs = @logs.select do |log|
        log.workout && log.workout.muscle_group.to_s == @selected_muscle
      end
    end
  end
end

# ===================================================================

# app/controllers/split_days_controller.rb

class SplitDaysController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_can_act_on_behalf!  # NEW

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
