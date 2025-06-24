class WorkoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_can_act_on_behalf!  # NEW
  before_action :set_split_day
  before_action :set_workout, only: [:show, :update, :destroy, :promote]

  def new
    @workout = @split_day.workouts.new
  end

  def create
    @workout = @split_day.workouts.build(workout_params)
    if @workout.save
      redirect_to split_plan_split_day_path(@split_day.split_plan, @split_day), notice: "Workout created."
    else
      render :new
    end
  end

  def show
    @workout = Workout.find(params[:id])
    @logs = @workout.workout_logs.order(created_at: :desc)
    # Use acting_user instead of viewing_user
    @recovery = RecoveryTracker.new(user_context.acting_user)
  end

  def update
    if @workout.update(workout_params)
      redirect_to split_plan_split_day_path(@split_day.split_plan, @split_day), notice: "Workout updated."
    else
      render :edit
    end
  end

  def promote
    log = @workout.workout_logs.find_by(id: params[:log_id])

    if log && log.details.present?
      @workout.update(details: log.details)
      redirect_to workout_path(@workout), notice: "✅ Benchmark updated!"
    else
      redirect_to workout_path(@workout), alert: "❌ Log not found or empty."
    end
  end

  def destroy
    @workout.destroy
    redirect_to split_plan_split_day_path(@split_day.split_plan, @split_day), notice: "Workout deleted."
  end

  private

  def set_split_day
    @split_day = SplitDay.find(params[:split_day_id])
  end

  def set_workout
    @workout = @split_day.workouts.find(params[:id])
  end

  def workout_params
    params.require(:workout).permit(:name, :muscle_group)
  end
end
