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
    # UPDATED: Use new all_muscle_groups method instead of WORKOUTS.key?
    @muscles = AppConstants::LABELS.select do |key, _label|
      user_muscle_groups.include?(key) && AppConstants.all_muscle_groups.include?(key)
    end

    @selected_muscle = params[:muscle]

    # 🚀 FIXED: Single query with ALL necessary preloading to eliminate N+1
    @logs = user_context.acting_user.workout_logs
                       .includes(:workout, :exercise_sets)  # Preload workout and exercise_sets
                       .order(created_at: :desc)

    if @selected_muscle.present?
      @logs = @logs.joins(:workout).where(workouts: { muscle_group: @selected_muscle })
    end

    # 🚀 FIXED: Force loading of associations to prevent lazy loading in views
    # This ensures that when we call log.exercise_sets in the view, it uses preloaded data
    @logs = @logs.to_a  # Convert to array to force query execution

    # Preload exercise_sets associations for all logs
    @logs.each do |log|
      log.association(:exercise_sets).target # Force load the association
    end
  end
end
