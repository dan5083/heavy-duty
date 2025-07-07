# app/controllers/dashboard_controller.rb

class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_can_act_on_behalf!

  def index
    # NEW: Determine view mode from params (default: recovery)
    @view_mode = params[:view] == 'benchmark' ? 'benchmark' : 'recovery'

    # NEW: Show client switcher for trainers
    if current_user.trainer?
      @clients = user_context.available_clients.includes(:split_plans)
      @viewing_client = user_context.acting_user unless user_context.acting_user == current_user
    end

    # Use acting_user instead of viewing_user
    latest_plan = user_context.acting_user.split_plans.last
    unless latest_plan
      return redirect_to new_split_plan_path, alert: "Please create a split plan first."
    end

    @workouts_by_muscle = latest_plan
      .split_days
      .includes(:workouts)
      .flat_map(&:workouts)
      .group_by { |w| w.muscle_group.to_sym }
      .transform_values(&:first)

    # Use acting_user for recovery tracking
    recovery = RecoveryTracker.new(user_context.acting_user)

    # Get muscles from current split plan
    muscles = latest_plan.split_days.pluck(:muscle_group).map(&:to_sym).uniq

    if @view_mode == 'benchmark'
      # NEW: Benchmark view data
      setup_benchmark_view(recovery, muscles)
    else
      # EXISTING: Recovery view data
      setup_recovery_view(recovery, muscles)
    end
  end

  private

  def setup_recovery_view(recovery, muscles)
    all_data = recovery.full_map
    filtered_data = all_data.slice(*muscles)

    @readiness_data = filtered_data.sort_by do |muscle, data|
      if data[:days_left] <= 0
        [0, -data[:days_ready], muscle.to_s]
      else
        [1, data[:days_left], muscle.to_s]
      end
    end.to_h

    # Find the muscle that's been ready the longest
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

    @view_title = "Recovery Status"
    @view_subtitle = "Track when muscles are ready to train again"
  end

  def setup_benchmark_view(recovery, muscles)
    all_benchmark_data = recovery.benchmark_map
    filtered_data = all_benchmark_data.slice(*muscles)

    # Sort by benchmark status: never benchmarked first, then by days since (oldest first)
    @readiness_data = filtered_data.sort_by do |muscle, data|
      if !data[:has_benchmark]
        [0, muscle.to_s] # Never benchmarked - highest priority
      else
        [1, -data[:days_since_benchmark], muscle.to_s] # Oldest benchmarks first
      end
    end.to_h

    # Find the muscle that needs a benchmark most urgently
    most_urgent = @readiness_data.find do |_, data|
      !data[:has_benchmark]
    end

    # If no muscles without benchmarks, find the oldest benchmark
    unless most_urgent
      oldest = @readiness_data.max_by { |_, data| data[:days_since_benchmark] || 0 }
      most_urgent = oldest if oldest&.last&.dig(:days_since_benchmark) && oldest.last[:days_since_benchmark] > 14
    end

    if most_urgent
      muscle, data = most_urgent
      @next_ready = {
        muscle: muscle,
        label: data[:label],
        days_since: data[:days_since_benchmark],
        last_benchmark_date: data[:last_benchmark_date],
        needs_benchmark: !data[:has_benchmark]
      }
    end

    @view_title = "Benchmark Status"
    @view_subtitle = "Track when muscles were last benchmarked"
  end
end
