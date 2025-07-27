module RecoveryHelper
 # === RECOVERY METHODS ===

 def readiness_label(ready_on_date)
   now = Time.current
   return "Good to Go" if ready_on_date <= now

   diff = ready_on_date - now
   days = (diff / 1.day).floor
   hours = ((diff % 1.day) / 1.hour).floor
   minutes = ((diff % 1.hour) / 1.minute).floor

   "Ready in #{days}d #{hours}h #{minutes}m"
 end

 def readiness_status_badge(days_left)
   if days_left <= 0
     tag.span("✅ Ready", class: "badge bg-success")
   elsif days_left <= 2
     tag.span("⏳ Soon", class: "badge bg-warning text-dark")
   else
     tag.span("🛑 Recovering", class: "badge bg-secondary")
   end
 end

 def current_split_muscles
   user_context.acting_user.split_plans.last&.split_days&.pluck(:muscle_group)&.map(&:to_sym)&.uniq || []
 end

 def log_path_for_muscle(muscle, workouts_by_muscle)
   workout = workouts_by_muscle[muscle]
   return nil unless workout

   new_split_plan_split_day_workout_workout_log_path(
     workout.split_day.split_plan,
     workout.split_day,
     workout
   )
 end

 def readiness_label(days_left)
   if days_left <= 0
     content_tag(:span, "✅ Good to Go", class: "text-success fw-bold")
   else
     content_tag(:span,
       "Ready in #{pluralize(days_left, 'day')}",
       class: "text-muted")
   end
 end

 # === CARDIO METHODS ===

 # Get cardio status for dashboard
 def cardio_status
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

 # Create or find standalone cardio workout structure
 def get_or_create_cardio_workout
   # Look for existing cardio workout first
   existing_cardio = Workout.joins(:split_day)
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

 # === BENCHMARK HELPER METHODS ===

 def benchmark_status_for(muscle, benchmark_data)
   data = benchmark_data[muscle]
   return nil unless data

   if data[:has_benchmark]
     days_since = data[:days_since_benchmark]
     {
       status: benchmark_status_type(days_since),
       label: data[:benchmark_age_label],
       days_since: days_since,
       last_date: data[:last_benchmark_date],
       urgency: benchmark_urgency(days_since)
     }
   else
     {
       status: :never,
       label: "Never benchmarked",
       days_since: nil,
       last_date: nil,
       urgency: :critical
     }
   end
 end

 def benchmark_status_badge(benchmark_status)
   return tag.span("❌ Never", class: "badge bg-danger") unless benchmark_status

   case benchmark_status[:status]
   when :fresh
     tag.span("🆕 Fresh", class: "badge bg-success")
   when :good
     tag.span("✅ Good", class: "badge bg-primary")
   when :aging
     tag.span("⏳ Aging", class: "badge bg-warning text-dark")
   when :stale
     tag.span("🔄 Stale", class: "badge bg-danger")
   when :never
     tag.span("❌ Never", class: "badge bg-danger")
   else
     tag.span("❓ Unknown", class: "badge bg-secondary")
   end
 end

 def benchmark_urgency_class(urgency)
   case urgency
   when :critical
     "border-danger"
   when :high
     "border-warning"
   when :medium
     "border-info"
   when :low
     "border-success"
   else
     "border-secondary"
   end
 end

 def benchmark_progress_percentage(days_since)
   return 0 if days_since.nil?

   # Consider 30 days as 100% stale
   max_days = 30
   percentage = [(days_since.to_f / max_days * 100).round, 100].min

   # Invert so fresh benchmarks show high percentage
   100 - percentage
 end

 def benchmark_progress_color(days_since)
   return "bg-danger" if days_since.nil?

   case days_since
   when 0..7
     "bg-success"
   when 8..14
     "bg-primary"
   when 15..21
     "bg-warning"
   else
     "bg-danger"
   end
 end

 def benchmark_action_button_text(benchmark_status, muscle_ready = false)
   return "Set First Benchmark" unless benchmark_status&.dig(:has_benchmark)

   case benchmark_status[:urgency]
   when :critical, :high
     "Update Benchmark"
   else
     "Beat Benchmark"
   end
 end

 def benchmark_action_button_class(benchmark_status, muscle_ready = false)
   return "btn btn-warning btn-sm w-100" unless benchmark_status&.dig(:has_benchmark)

   case benchmark_status[:urgency]
   when :critical
     "btn btn-danger btn-sm w-100"
   when :high
     "btn btn-warning btn-sm w-100"
   when :medium
     muscle_ready ? "btn btn-success btn-sm w-100" : "btn btn-outline-primary btn-sm w-100"
   else
     muscle_ready ? "btn btn-success btn-sm w-100" : "btn btn-outline-light btn-sm w-100"
   end
 end

 def next_ready_description(next_ready)
   return nil unless next_ready

   if next_ready[:days_ready] && next_ready[:days_ready] > 0
     "#{next_ready[:label]} has been ready for #{pluralize(next_ready[:days_ready], 'day')}"
   else
     "#{next_ready[:label]} will be ready in #{pluralize(next_ready[:days_left], 'day')}"
   end
 end

 private

 def benchmark_status_type(days_since)
   case days_since
   when 0..7
     :fresh
   when 8..14
     :good
   when 15..21
     :aging
   else
     :stale
   end
 end

 def benchmark_urgency(days_since)
   case days_since
   when 0..7
     :low
   when 8..14
     :medium
   when 15..21
     :high
   else
     :critical
   end
 end
end
