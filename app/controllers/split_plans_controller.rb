class SplitPlansController < ApplicationController
  def index
    @split_plans = current_user.split_plans.order(created_at: :desc)
  end

  def new
    @split_plan = SplitPlan.new
    @split_data = AppConstants::SPLITS
    @label_data = AppConstants::LABELS
  end

  def create
    selected_label = params[:split_plan_choice]
    selected_split = AppConstants::SPLITS[selected_label.to_sym]

    # Create the plan
    @split_plan = current_user.split_plans.create!(
      name: selected_label,
      split_length: selected_split.length
    )

    # Create associated split days
    selected_split.each_with_index do |muscle_group, i|
      @split_plan.split_days.create!(
        day_number: i + 1,
        muscle_group: muscle_group
      )
    end

    # 🆕 Redirect to post-creation recovery seeding
    redirect_to initialize_recovery_split_plan_path(@split_plan),
                notice: "Split plan created! Now let’s set up your recent training."
  end

  def initialize_recovery
    @split_plan = SplitPlan.find(params[:id])
    @muscles = @split_plan.split_days.pluck(:muscle_group).uniq.map(&:to_sym)
  end

  def submit_recovery
    @split_plan = SplitPlan.find(params[:id])
    recovery_dates = params[:recovery_dates] || {}

    recovery_dates.each do |muscle_group, date|
      workout = Workout.find_or_create_by!(
        split_day: @split_plan.split_days.find_by(muscle_group: muscle_group),
        muscle_group: muscle_group
      )

      WorkoutLog.create!(
        user: current_user,
        workout: workout,
        created_at: date.to_date
      )
    end

    redirect_to dashboard_path, notice: "Recovery initialized successfully."
  end

  def show
    @split_plan = SplitPlan.find(params[:id])
  end

  def destroy
    @split_plan = SplitPlan.find(params[:id])
    @split_plan.destroy
    redirect_to split_plans_path, notice: "Split plan deleted."
  end

  private

  def split_plan_params
    params.require(:split_plan).permit(:name, :split_length)
  end
end
