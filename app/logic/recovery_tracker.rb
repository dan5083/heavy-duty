# app/logic/recovery_tracker.rb
class RecoveryTracker
 def initialize(user)
   @user = user
 end

 # === RECOVERY METHODS ===

 def ready_date_for(muscle)
   last_log = @user.workout_logs
                   .joins(:workout)
                   .where(workouts: { muscle_group: muscle })
                   .order(created_at: :desc)
                   .first

   return Date.today if last_log.nil?

   cooldown = AppConstants::TRAINING_CYCLE[muscle]
   last_log.created_at + cooldown.days  # Remove .to_date
 end

 def countdown_days_for(muscle)
   ready_date = ready_date_for(muscle).to_date  # Convert to Date
   (ready_date - Date.today).to_i
 end

 def forecast(days_ahead: 10)
   AppConstants::TRAINING_CYCLE.keys.index_with do |muscle|
     ready_on = ready_date_for(muscle)
     Array.new(days_ahead) do |offset|
       day = Date.today + offset
       day >= ready_on ? :ready : :recovering
     end
   end
 end

 def next_ready_muscle
   future_recovery = AppConstants::TRAINING_CYCLE.keys.map do |muscle|
     ready_on = ready_date_for(muscle)
     next if ready_on <= Date.today # already ready

     [muscle, ready_on]
   end.compact

   return nil if future_recovery.empty?

   muscle, date = future_recovery.min_by { |_, d| d }

   {
     muscle: muscle,
     label: AppConstants::LABELS[muscle],
     ready_on: date,
     days_left: (date - Date.today).to_i
   }
 end

 def full_map
   AppConstants::TRAINING_CYCLE.keys.index_with do |muscle|
     ready_on = ready_date_for(muscle)
     days_left = countdown_days_for(muscle)

     {
       ready_on: ready_on,
       days_left: days_left,
       days_ready: days_left <= 0 ? days_left.abs : nil,
       label: AppConstants::LABELS[muscle]
     }.merge(benchmark_data_for(muscle))
   end
 end

 # === BENCHMARK METHODS ===

 def last_benchmark_date_for(muscle)
   benchmark_log = @user.workout_logs
                        .joins(:workout)
                        .where(workouts: { muscle_group: muscle }, is_benchmark: true)
                        .order(created_at: :desc)
                        .first

   benchmark_log&.created_at&.to_date
 end

 def days_since_benchmark_for(muscle)
   last_benchmark = last_benchmark_date_for(muscle)
   return nil if last_benchmark.nil?

   (Date.today - last_benchmark).to_i
 end

 def has_benchmark_for?(muscle)
   last_benchmark_date_for(muscle).present?
 end

 def benchmark_map
   AppConstants::TRAINING_CYCLE.keys.index_with do |muscle|
     benchmark_data_for(muscle)
   end
 end

 def oldest_benchmark
   benchmarks_with_dates = AppConstants::TRAINING_CYCLE.keys.map do |muscle|
     days_since = days_since_benchmark_for(muscle)
     next if days_since.nil?

     {
       muscle: muscle,
       label: AppConstants::LABELS[muscle],
       days_since: days_since,
       last_benchmark_date: last_benchmark_date_for(muscle)
     }
   end.compact

   return nil if benchmarks_with_dates.empty?

   benchmarks_with_dates.max_by { |data| data[:days_since] }
 end

 def newest_benchmark
   benchmarks_with_dates = AppConstants::TRAINING_CYCLE.keys.map do |muscle|
     days_since = days_since_benchmark_for(muscle)
     next if days_since.nil?

     {
       muscle: muscle,
       label: AppConstants::LABELS[muscle],
       days_since: days_since,
       last_benchmark_date: last_benchmark_date_for(muscle)
     }
   end.compact

   return nil if benchmarks_with_dates.empty?

   benchmarks_with_dates.min_by { |data| data[:days_since] }
 end

 def muscles_needing_benchmarks
   AppConstants::TRAINING_CYCLE.keys.select do |muscle|
     !has_benchmark_for?(muscle)
   end
 end

 private

 def benchmark_data_for(muscle)
   last_benchmark = last_benchmark_date_for(muscle)
   days_since = days_since_benchmark_for(muscle)

   {
     last_benchmark_date: last_benchmark,
     days_since_benchmark: days_since,
     has_benchmark: last_benchmark.present?,
     benchmark_age_label: benchmark_age_label(days_since)
   }
 end

 def benchmark_age_label(days_since)
   return "Never benchmarked" if days_since.nil?

   case days_since
   when 0
     "Today"
   when 1
     "Yesterday"
   when 2..6
     "#{days_since} days ago"
   when 7..13
     "1 week ago"
   when 14..29
     "#{(days_since / 7.0).round} weeks ago"
   when 30..89
     "#{(days_since / 30.0).round} months ago"
   else
     "#{(days_since / 365.0).round} years ago"
   end
 end
end
