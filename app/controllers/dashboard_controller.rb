# app/controllers/dashboard_controller.rb

class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_can_act_on_behalf!

  def index
    # Show client switcher for trainers
    if current_user.trainer?
      @clients = user_context.available_clients.includes(:split_plans)
    end

    # Use acting_user instead of viewing_user
    latest_plan = user_context.acting_user.split_plans.last
    unless latest_plan
      # Only show alert if they came from trying to create a split plan
      if params[:from_split_creation] == 'failed'
        redirect_to new_split_plan_path, alert: "Please create a split plan first."
        return
      else
        redirect_to new_split_plan_path
        return
      end
    end

    # 🚀 OPTIMIZED: Single query with comprehensive preloading
    @workouts_by_muscle = latest_plan
      .split_days
      .includes(workouts: :workout_logs)  # Preload workouts and their logs
      .flat_map(&:workouts)
      .group_by { |w| w.muscle_group.to_sym }
      .transform_values(&:first)

    # 🚀 OPTIMIZED: Use memoized recovery tracker to prevent duplicate queries
    recovery = recovery_tracker

    # Get muscles from current split plan - EXCLUDE cardio
    muscles = latest_plan.split_days.pluck(:muscle_group).map(&:to_sym).uniq.reject { |muscle| muscle == :cardio }

    # Get unified data combining recovery and benchmark info
    all_recovery_data = recovery.full_map
    all_benchmark_data = recovery.benchmark_map

    # Combine recovery and benchmark data - FILTER OUT cardio
    filtered_data = muscles.map do |muscle|
      recovery_data = all_recovery_data[muscle] || {}
      benchmark_data = all_benchmark_data[muscle] || {}

      [muscle, recovery_data.merge(benchmark_data)]
    end.to_h

    # Sort by readiness - ready muscles first, then by how long they've been ready
    @readiness_data = filtered_data.sort_by do |muscle, data|
      if data[:days_left] <= 0
        [0, -data[:days_ready], muscle.to_s]
      else
        [1, data[:days_left], muscle.to_s]
      end
    end.to_h

    # Find the muscle that's been ready the longest for priority alert
    longest_ready = @readiness_data.find { |_, data| data[:days_left] <= 0 && data[:days_ready] > 0 }
    if longest_ready
      muscle, data = longest_ready
      @next_ready = {
        muscle: muscle,
        label: data[:label],
        ready_on: data[:ready_on],
        days_ready: data[:days_ready]
      }
    end

    # 🚀 OPTIMIZED: Get cardio data more efficiently
    @cardio_status = get_cardio_status_optimized
    @cardio_workout = get_or_create_cardio_workout_optimized(latest_plan)
  end

  private

  # 🚀 NEW: Memoized recovery tracker to prevent duplicate instantiation
  def recovery_tracker
    @recovery_tracker ||= RecoveryTracker.new(user_context.acting_user)
  end

  # 🚀 OPTIMIZED: More efficient cardio status check
  def get_cardio_status_optimized
    # Reuse the recovery tracker's preloaded data if possible
    recovery = recovery_tracker

    # Check if cardio data is in the preloaded data
    latest_by_muscle = recovery.preloaded_data[:latest_by_muscle]
    last_cardio_log = latest_by_muscle['cardio']

    if last_cardio_log.nil?
      { completed: false, last_cardio_time: nil }
    else
      hours_since = (Time.current - last_cardio_log.created_at) / 1.hour
      {
        completed: hours_since < 16,
        last_cardio_time: last_cardio_log.created_at
      }
    end
  end

  # 🚀 OPTIMIZED: More efficient cardio workout lookup
  def get_or_create_cardio_workout_optimized(split_plan)
    # Look for existing cardio workout using preloaded associations
    existing_cardio = @workouts_by_muscle[:cardio]
    return existing_cardio if existing_cardio

    # If no cardio in current workouts, check if we need to create the structure
    cardio_split_day = split_plan.split_days.find_or_create_by(
      muscle_group: 'cardio'
    ) do |split_day|
      split_day.day_number = split_plan.split_days.count + 1
      split_day.label = "Daily Cardio"
    end

    # Create cardio workout
    cardio_workout = cardio_split_day.workouts.create!(
      name: "Daily Cardio",
      muscle_group: 'cardio'
    )

    # Update the workouts_by_muscle hash for consistency
    @workouts_by_muscle[:cardio] = cardio_workout

    cardio_workout
  end

  # OLD METHOD - keep as fallback but shouldn't be called
  def get_cardio_status
    last_cardio_log = user_context.acting_user.workout_logs
                                 .joins(:workout)
                                 .where(workouts: { muscle_group: 'cardio' })
                                 .order(created_at: :desc)
                                 .first

    if last_cardio_log.nil?
      { completed: false, last_cardio_time: nil }
    else
      hours_since = (Time.current - last_cardio_log.created_at) / 1.hour
      {
        completed: hours_since < 16,
        last_cardio_time: last_cardio_log.created_at
      }
    end
  end

  def get_or_create_cardio_workout
    # Look for existing cardio workout first - preload associations to avoid N+1
    existing_cardio = Workout.joins(:split_day)
                             .includes(:split_day, split_day: :split_plan)
                             .where(muscle_group: 'cardio')
                             .where(split_days: {
                               split_plan: user_context.acting_user.split_plans.last
                             })
                             .first

    return existing_cardio if existing_cardio

    # If no current split plan, create a minimal one for cardio
    split_plan = user_context.acting_user.split_plans.last

    unless split_plan
      split_plan = user_context.acting_user.split_plans.create!(
        name: "Basic Plan with Cardio",
        split_length: 1,
        is_custom: false
      )
    end

    # Create cardio split day if it doesn't exist
    cardio_split_day = split_plan.split_days.find_or_create_by(
      muscle_group: 'cardio'
    ) do |split_day|
      split_day.day_number = split_plan.split_days.count + 1
      split_day.label = "Daily Cardio"
    end

    # Create cardio workout
    cardio_split_day.workouts.create!(
      name: "Daily Cardio",
      muscle_group: 'cardio'
    )
  end
end
