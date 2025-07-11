class SplitPlansController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_can_act_on_behalf!  # NEW

  def index
    # Use acting_user instead of viewing_user
    @split_plans = user_context.acting_user.split_plans.order(created_at: :desc)
  end

  def new
    @split_plan = SplitPlan.new
    @split_data = AppConstants::SPLITS
    @label_data = AppConstants::LABELS
  end

  def show
    @split_plan = SplitPlan.find(params[:id])
    # Redirect to index since you don't want a show page
    redirect_to split_plans_path
  end

  # Custom split builder page
  def build_custom
    @split_plan = SplitPlan.new
    @available_muscles = AppConstants::CUSTOM_SPLIT_MUSCLES
    @recovery_options = AppConstants::RECOVERY_OPTIONS
    @muscle_labels = AppConstants::LABELS
  end

  def create
    selected_label = params[:split_plan_choice]

    # Handle custom split creation
    if selected_label == 'custom_split'
      redirect_to build_custom_split_plans_path
      return
    end

    selected_split = AppConstants::SPLITS[selected_label.to_sym]

    # Create the plan for acting_user instead of viewing_user
    @split_plan = user_context.acting_user.split_plans.create!(
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

  # Create custom split
  def create_custom
    muscle_selections = params[:muscle_selections] || {}
    recovery_days = params[:recovery_days] || {}

    # Filter only selected muscles with their recovery days
    custom_config = {}
    muscle_selections.each do |muscle, selected|
      if selected == '1' && recovery_days[muscle].present?
        custom_config[muscle] = recovery_days[muscle].to_i
      end
    end

    # Validate we have at least one muscle
    if custom_config.empty?
      redirect_to build_custom_split_plan_path,
                  alert: "Please select at least one muscle group."
      return
    end

    # Create the custom split plan for acting_user instead of viewing_user
    @split_plan = user_context.acting_user.split_plans.new
    @split_plan.set_custom_config(custom_config)

    if @split_plan.save
      # Create split days for each selected muscle
      custom_config.each_with_index do |(muscle_group, _recovery_days), index|
        @split_plan.split_days.create!(
          day_number: index + 1,
          muscle_group: muscle_group.to_s
        )
      end

      # Redirect to recovery initialization
      redirect_to initialize_recovery_split_plan_path(@split_plan),
                  notice: "Custom split created! Now let's set up your recent training."
    else
      @available_muscles = AppConstants::CUSTOM_SPLIT_MUSCLES
      @recovery_options = AppConstants::RECOVERY_OPTIONS
      @muscle_labels = AppConstants::LABELS
      render :build_custom, alert: "Failed to create custom split: #{@split_plan.errors.full_messages.join(', ')}"
    end
  end

  def initialize_recovery
    @split_plan = SplitPlan.find(params[:id])
    @muscles = @split_plan.split_days.pluck(:muscle_group).uniq.map(&:to_sym)
  end

  def submit_recovery
    @split_plan = SplitPlan.find(params[:id])
    recovery_dates = params[:recovery_dates] || {}

    # Validate that all muscles have dates
    muscles = @split_plan.split_days.pluck(:muscle_group).uniq.map(&:to_sym)
    missing_dates = muscles.select { |muscle| recovery_dates[muscle.to_s].blank? }

    if missing_dates.any?
      muscle_labels = missing_dates.map { |muscle| AppConstants::LABELS[muscle] }
      flash[:alert] = "Please enter dates for: #{muscle_labels.join(', ')}"
      return render :initialize_recovery
    end

    ActiveRecord::Base.transaction do
      recovery_dates.each do |muscle_group, date|
        split_day = @split_plan.split_days.find_by(muscle_group: muscle_group)

        # Create workout with proper name
        workout = split_day.workouts.create!(
          name: AppConstants::LABELS[muscle_group.to_sym],
          muscle_group: muscle_group
        )

        # Create simple workout log for recovery tracking only
        WorkoutLog.create!(
          user: user_context.acting_user,
          workout: workout,
          created_at: date.to_date
          # REMOVED: is_benchmark: true
          # REMOVED: generate_initial_exercise_sets call
          # No exercise_sets created - this is purely for recovery date tracking
        )
      end
    end

    redirect_to dashboard_path, notice: "Recovery tracking initialized. Log real workouts to set benchmarks!"
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

  # REMOVED: generate_initial_exercise_sets method entirely
end
