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
                notice: "Split plan created! Now let's set up your recent training."
  end

  def initialize_recovery
    @split_plan = SplitPlan.find(params[:id])
    @muscles = @split_plan.split_days.pluck(:muscle_group).uniq.map(&:to_sym)
  end

  def submit_recovery
    @split_plan = SplitPlan.find(params[:id])

    if params[:skip] == 'true'
      muscles = @split_plan.split_days.pluck(:muscle_group).uniq.map(&:to_sym)
      recovery_dates = muscles.to_h { |muscle| [muscle.to_s, 3.weeks.ago.to_date] }
    else
      recovery_dates = params[:recovery_dates] || {}
    end

    recovery_dates.each do |muscle_group, date|
      split_day = @split_plan.split_days.find_by(muscle_group: muscle_group)

      # 🆕 Generate benchmark data using consistent defaults
      benchmark_data = generate_initial_benchmark(muscle_group.to_sym)

      # Create workout with proper name and details
      workout = split_day.workouts.create!(
        name: AppConstants::LABELS[muscle_group.to_sym],
        muscle_group: muscle_group,
        details: benchmark_data.to_json
      )

      WorkoutLog.create!(
        user: current_user,
        workout: workout,
        details: benchmark_data.to_json,
        created_at: date.to_date
      )
    end

    redirect_to dashboard_path, notice: "Recovery initialized successfully."
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

  # 🆕 Generate initial benchmark with consistent defaults
  def generate_initial_benchmark(muscle_group)
    exercises = AppConstants::WORKOUTS[muscle_group] || []
    return {} if exercises.empty?

    # Pick 2-4 exercises for the initial benchmark (keeping exercise variety)
    selected_exercises = exercises.sample(rand(2..4))

    benchmark = {}
    selected_exercises.each do |exercise|
      # Generate EXACTLY 1 SET using consistent default format
      benchmark[exercise] = [generate_set_description(1, exercise)]
    end

    benchmark
  end

  def generate_set_description(set_number, exercise)
    # Use consistent defaults that match JavaScript format
    "Working set, 1 REPS, AT 1 KILOS, solid effort"
  end
end
