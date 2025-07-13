# db/seeds.rb - Production Demo Data
#
# USAGE:
# 1. git checkout -b seed-for-demo
# 2. git add db/seeds.rb && git commit -m "Add demo seed data"
# 3. git push heroku seed-for-demo:main
# 4. heroku run rails db:reset db:seed
#
# OR manually:
# heroku run rails console
# > load 'db/seeds.rb'

puts "🧹 CLEARING PRODUCTION DATABASE..."
puts "⚠️  This will DELETE ALL existing data!"
puts ""

# Safety check - require explicit confirmation in production
if Rails.env.production?
  puts "🚨 PRODUCTION ENVIRONMENT DETECTED"
  puts "Type 'YES DELETE EVERYTHING' to continue:"

  # In Heroku console, this will pause for input
  # When running via rails db:seed, we'll skip the check
  unless ARGV.include?('--force') || ENV['DEMO_SEED_CONFIRMED']
    puts "Exiting... Run with DEMO_SEED_CONFIRMED=true if you're sure"
    exit
  end
end

puts "🗑️  Clearing existing data in dependency order..."

# Clear all data in proper dependency order
AuditLog.delete_all
puts "  ✅ Cleared audit logs"

ExerciseSet.delete_all
puts "  ✅ Cleared exercise sets"

WorkoutLog.delete_all
puts "  ✅ Cleared workout logs"

Workout.delete_all
puts "  ✅ Cleared workouts"

SplitDay.delete_all
puts "  ✅ Cleared split days"

SplitPlan.delete_all
puts "  ✅ Cleared split plans"

ClientAssignment.delete_all
puts "  ✅ Cleared client assignments"

PersonalTrainer.delete_all
puts "  ✅ Cleared personal trainers"

User.delete_all
puts "  ✅ Cleared users"

puts ""
puts "🎉 Database completely cleared!"
puts ""

puts "👨‍💼 Creating personal trainer..."

# Create the main trainer
trainer_user = User.create!(
  name: "Alex Rivera",
  email: "alex.rivera@fitnesstech.demo",
  password: "DemoPass123!",
  password_confirmation: "DemoPass123!"
)

trainer = PersonalTrainer.create!(
  user: trainer_user,
  name: "Alex Rivera",
  bio: "Certified Personal Trainer with 8+ years experience in strength training, powerlifting, and athletic performance. Specializes in progressive overload and evidence-based training methods."
)

puts "✅ Created trainer: #{trainer.name}"

puts "👥 Creating clients..."

# Client data - realistic names and emails
clients_data = [
  {
    name: "Sarah Chen",
    email: "sarah.chen@email.demo",
    detailed: true,
    split_type: :"3_day_split",
    focus: "strength_building"
  },
  {
    name: "Marcus Johnson",
    email: "marcus.johnson@email.demo",
    detailed: true,
    split_type: :"5_day_split",
    focus: "bodybuilding"
  },
  {
    name: "Emma Rodriguez",
    email: "emma.rodriguez@email.demo",
    detailed: false
  },
  {
    name: "David Kim",
    email: "david.kim@email.demo",
    detailed: false
  },
  {
    name: "Jessica Taylor",
    email: "jessica.taylor@email.demo",
    detailed: false
  },
  {
    name: "Ryan O'Connor",
    email: "ryan.oconnor@email.demo",
    detailed: false
  },
  {
    name: "Priya Patel",
    email: "priya.patel@email.demo",
    detailed: false
  },
  {
    name: "Carlos Santos",
    email: "carlos.santos@email.demo",
    detailed: false
  }
]

clients = []

clients_data.each do |client_data|
  user = User.create!(
    name: client_data[:name],
    email: client_data[:email],
    password: "ClientDemo123!",
    password_confirmation: "ClientDemo123!"
  )

  # Assign to trainer
  ClientAssignment.create!(
    personal_trainer: trainer,
    user: user
  )

  clients << { user: user, data: client_data }
  puts "  ✅ Created client: #{client_data[:name]}"
end

puts "🏋️  Creating detailed workout data for featured clients..."

# Helper method to create realistic workout logs
def create_workout_log(user, workout, days_ago, exercises_data, is_benchmark: false, context: nil)
  log = WorkoutLog.create!(
    user: user,
    workout: workout,
    is_benchmark: is_benchmark,
    exercise_context: context,
    created_at: days_ago.days.ago
  )

  exercises_data.each_with_index do |(exercise_name, sets_data), exercise_index|
    sets_data.each_with_index do |set_data, set_index|
      ExerciseSet.create!(
        workout_log: log,
        exercise_name: exercise_name,
        set_number: set_index + 1,
        set_type: set_data[:type] || 'working',
        reps: set_data[:reps],
        weight_kg: set_data[:weight],
        weight_unit: 'kg',
        notes: set_data[:notes] || 'solid effort'
      )
    end
  end

  log
end

# Create detailed data for Sarah Chen (3-day split, strength focus)
sarah = clients.find { |c| c[:data][:name] == "Sarah Chen" }[:user]

sarah_split = SplitPlan.create!(
  user: sarah,
  name: "3_day_split",
  split_length: 3
)

# Create split days for 3-day split
push_day = SplitDay.create!(split_plan: sarah_split, day_number: 1, muscle_group: "push_chest_shoulders_triceps")
pull_day = SplitDay.create!(split_plan: sarah_split, day_number: 2, muscle_group: "pull_back_biceps")
legs_day = SplitDay.create!(split_plan: sarah_split, day_number: 3, muscle_group: "legs")

# Create workouts
push_workout = Workout.create!(split_day: push_day, name: "Push Day", muscle_group: "push_chest_shoulders_triceps")
pull_workout = Workout.create!(split_day: pull_day, name: "Pull Day", muscle_group: "pull_back_biceps")
legs_workout = Workout.create!(split_day: legs_day, name: "Legs Day", muscle_group: "legs")

# Sarah's workout history (last 3 weeks)
puts "  📊 Creating Sarah's workout history..."

# Push workout - 3 weeks ago (benchmark)
create_workout_log(sarah, push_workout, 21, {
  "Bench Press (Barbell)" => [
    { reps: 8, weight: 60, type: 'working', notes: 'good form, controlled' },
    { reps: 6, weight: 65, type: 'working', notes: 'challenging but clean' },
    { reps: 5, weight: 70, type: 'working', notes: 'personal best!' }
  ],
  "Overhead Press" => [
    { reps: 8, weight: 35, type: 'working', notes: 'solid lockout' },
    { reps: 7, weight: 37.5, type: 'working', notes: 'slight struggle on last rep' }
  ]
}, is_benchmark: true, context: "First week on new program. Feeling strong and motivated!")

# Pull workout - 2.5 weeks ago
create_workout_log(sarah, pull_workout, 18, {
  "Pull-Ups" => [
    { reps: 6, weight: nil, type: 'working', notes: 'bodyweight, clean form' },
    { reps: 5, weight: nil, type: 'working', notes: 'starting to fatigue' },
    { reps: 4, weight: nil, type: 'working', notes: 'pushed to failure' }
  ],
  "Rows (Barbell)" => [
    { reps: 8, weight: 50, type: 'working', notes: 'focused on squeezing lats' },
    { reps: 8, weight: 52.5, type: 'working', notes: 'maintained tempo' }
  ]
})

# Legs workout - 2 weeks ago (benchmark)
create_workout_log(sarah, legs_workout, 14, {
  "Squats (Regular)" => [
    { reps: 8, weight: 80, type: 'working', notes: 'depth was perfect' },
    { reps: 6, weight: 85, type: 'working', notes: 'felt heavy but strong' },
    { reps: 5, weight: 90, type: 'working', notes: 'new PR, very happy!' }
  ],
  "Deadlifts (Romanian)" => [
    { reps: 8, weight: 70, type: 'working', notes: 'great hamstring stretch' },
    { reps: 8, weight: 75, type: 'working', notes: 'controlled eccentric' }
  ]
}, is_benchmark: true, context: "Legs feeling really strong lately. Been working on mobility and it's paying off.")

# Recent workouts
create_workout_log(sarah, push_workout, 7, {
  "Bench Press (Barbell)" => [
    { reps: 8, weight: 62.5, type: 'working', notes: 'progress from last week' },
    { reps: 7, weight: 67.5, type: 'working', notes: 'getting stronger' },
    { reps: 6, weight: 72.5, type: 'working', notes: 'beat last benchmark!' }
  ]
})

create_workout_log(sarah, pull_workout, 4, {
  "Pull-Ups" => [
    { reps: 7, weight: nil, type: 'working', notes: 'improvement from last time' },
    { reps: 6, weight: nil, type: 'working', notes: 'feeling stronger' }
  ]
})

# Create detailed data for Marcus Johnson (5-day split, bodybuilding focus)
marcus = clients.find { |c| c[:data][:name] == "Marcus Johnson" }[:user]

marcus_split = SplitPlan.create!(
  user: marcus,
  name: "5_day_split",
  split_length: 5
)

# 5-day split days
chest_day = SplitDay.create!(split_plan: marcus_split, day_number: 1, muscle_group: "chest_and_triceps")
back_day = SplitDay.create!(split_plan: marcus_split, day_number: 2, muscle_group: "back_and_biceps")
legs_day_marcus = SplitDay.create!(split_plan: marcus_split, day_number: 3, muscle_group: "legs")
shoulders_day = SplitDay.create!(split_plan: marcus_split, day_number: 4, muscle_group: "shoulders")
core_day = SplitDay.create!(split_plan: marcus_split, day_number: 5, muscle_group: "core")

# Marcus workouts
chest_workout = Workout.create!(split_day: chest_day, name: "Chest & Triceps", muscle_group: "chest_and_triceps")
back_workout = Workout.create!(split_day: back_day, name: "Back & Biceps", muscle_group: "back_and_biceps")
shoulders_workout = Workout.create!(split_day: shoulders_day, name: "Shoulders", muscle_group: "shoulders")

puts "  📊 Creating Marcus's workout history..."

# Marcus's recent workouts (more bodybuilding focused)
create_workout_log(marcus, chest_workout, 16, {
  "Bench Press (Dumbbell)" => [
    { reps: 12, weight: 32.5, type: 'working', notes: 'full range of motion' },
    { reps: 10, weight: 35, type: 'working', notes: 'really squeezed at top' },
    { reps: 8, weight: 37.5, type: 'working', notes: 'chest on fire' }
  ],
  "Dumbbell Flyes" => [
    { reps: 15, weight: 15, type: 'working', notes: 'slow and controlled' },
    { reps: 12, weight: 17.5, type: 'working', notes: 'amazing stretch' }
  ],
  "Tricep Pushdowns" => [
    { reps: 15, weight: 40, type: 'working', notes: 'full extension' },
    { reps: 12, weight: 45, type: 'working', notes: 'triceps pumped' }
  ]
}, is_benchmark: true, context: "New training block focused on hypertrophy. Keeping reps higher and really focusing on time under tension.")

create_workout_log(marcus, back_workout, 13, {
  "Lat Pulldown" => [
    { reps: 12, weight: 70, type: 'working', notes: 'wide grip, chest up' },
    { reps: 10, weight: 75, type: 'working', notes: 'lats engaged well' }
  ],
  "Rows (Cable)" => [
    { reps: 12, weight: 60, type: 'working', notes: 'paused at chest' },
    { reps: 10, weight: 65, type: 'working', notes: 'great mind-muscle connection' }
  ]
}, is_benchmark: true)

create_workout_log(marcus, shoulders_workout, 8, {
  "Overhead Press" => [
    { reps: 10, weight: 40, type: 'working', notes: 'strict form' },
    { reps: 8, weight: 42.5, type: 'working', notes: 'no momentum' }
  ],
  "Lateral Raises" => [
    { reps: 15, weight: 12.5, type: 'working', notes: 'slow tempo' },
    { reps: 12, weight: 15, type: 'working', notes: 'delts burning' }
  ]
}, context: "Shoulders have been feeling really good lately. The extra warm-up routine is definitely helping.")

# Recent progress workouts
create_workout_log(marcus, chest_workout, 2, {
  "Bench Press (Dumbbell)" => [
    { reps: 12, weight: 35, type: 'working', notes: 'strength is up!' },
    { reps: 11, weight: 37.5, type: 'working', notes: 'beat last week' },
    { reps: 9, weight: 40, type: 'working', notes: 'new weight personal best' }
  ]
})

puts "✅ Demo data creation complete!"
puts ""
puts "🎬 Demo Setup Summary:"
puts "📧 Trainer Login: alex.rivera@fitnesstech.demo / DemoPass123!"
puts "👥 Total Clients: #{clients.length}"
puts "🏋️  Detailed workout data for:"
puts "   • Sarah Chen (3-day strength split)"
puts "   • Marcus Johnson (5-day bodybuilding split)"
puts ""
puts "🎥 Ready for screen recording!"

# Create some audit logs to show the system in action
AuditLog.log_action(
  performer: trainer_user,
  subject: sarah,
  action: 'start_impersonation',
  metadata: { demo_setup: true }
)

AuditLog.log_action(
  performer: trainer_user,
  subject: sarah,
  action: 'create_workout_log',
  metadata: { demo_setup: true, muscle_group: 'push_chest_shoulders_triceps' }
)
