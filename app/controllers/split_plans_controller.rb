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

    # Redirect to post-creation recovery seeding
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

    ActiveRecord::Base.transaction do
      recovery_dates.each do |muscle_group, date|
        split_day = @split_plan.split_days.find_by(muscle_group: muscle_group)

        # Create workout with proper name
        workout = split_day.workouts.create!(
          name: AppConstants::LABELS[muscle_group.to_sym],
          muscle_group: muscle_group
        )

        # Create workout log and exercise sets in one transaction
        workout_log = WorkoutLog.new(
          user: current_user,
          workout: workout,
          created_at: date.to_date
        )

        # Create initial benchmark exercise sets BEFORE saving the workout_log
        generate_initial_exercise_sets(workout_log, muscle_group.to_sym)

        # Now save the workout_log with exercise_sets already present
        workout_log.save!

        # Mark this workout log as the benchmark
        workout_log.update!(is_benchmark: true)
      end
    end

    redirect_to dashboard_path, notice: "Recovery initialized successfully."
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to initialize recovery: #{e.message}"
    redirect_to initialize_recovery_split_plan_path(@split_plan),
                alert: "Failed to initialize recovery: #{e.message}"
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

  # Generate initial benchmark with consistent defaults using ExerciseSet
  def generate_initial_exercise_sets(workout_log, muscle_group)
    exercises = AppConstants::WORKOUTS[muscle_group] || []
    return if exercises.empty?

    # Pick 2-4 exercises for the initial benchmark
    selected_exercises = exercises.sample(rand(2..4))

    selected_exercises.each_with_index do |exercise_name, index|
      # Build exercise sets (don't create yet, just build)
      workout_log.exercise_sets.build(
        exercise_name: exercise_name,
        set_number: 1,
        set_type: 'working',
        reps: 1,
        weight_kg: 1.0,
        weight_unit: 'kg',
        notes: 'solid effort'
      )
    end
  end
end
