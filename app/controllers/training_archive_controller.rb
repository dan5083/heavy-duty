class TrainingArchiveController < ApplicationController
  def index
    @muscles = AppConstants::LABELS
    @selected_muscle = params[:muscle]

    @logs = current_user.workout_logs.includes(:workout).order(created_at: :desc)

    if @selected_muscle.present?
      @logs = @logs.select do |log|
        log.workout && log.workout.muscle_group.to_s == @selected_muscle
      end
    end
  end
end
