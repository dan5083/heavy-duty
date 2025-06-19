class TrainingArchiveController < ApplicationController
  def index
    # Get only muscle groups that the current user actually has workouts for
    user_muscle_groups = current_user.workout_logs
                                    .joins(:workout)
                                    .distinct
                                    .pluck('workouts.muscle_group')
                                    .map(&:to_sym)

    # Filter LABELS to only include muscle groups the user has (exclude split plan labels)
    @muscles = AppConstants::LABELS.select do |key, _label|
      user_muscle_groups.include?(key) && AppConstants::WORKOUTS.key?(key)
    end

    @selected_muscle = params[:muscle]

    @logs = current_user.workout_logs.includes(:workout).order(created_at: :desc)

    if @selected_muscle.present?
      @logs = @logs.select do |log|
        log.workout && log.workout.muscle_group.to_s == @selected_muscle
      end
    end
  end
end
