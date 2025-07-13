puts "🏋️ Adding demo data to existing database..."

# Check if Alex already exists
if User.exists?(email: "alex.rivera@fitnesstech.com")
  puts "❌ Alex Rivera already exists, skipping seed"
  exit
end

puts "👨‍💼 Creating personal trainer..."

# Create the main trainer with proper email
trainer_user = User.create!(
  name: "Alex Rivera",
  email: "alex.rivera@fitnesstech.com",
  password: "DemoPass123!",
  password_confirmation: "DemoPass123!"
)

trainer = PersonalTrainer.create!(
  user: trainer_user,
  name: "Alex Rivera",
  bio: "Certified Personal Trainer with 8+ years experience in strength training, powerlifting, and athletic performance. Specializes in progressive overload and evidence-based training methods."
)

puts "✅ Created trainer: #{trainer.name} (#{trainer_user.email})"

puts "👥 Creating clients..."

# Client data - realistic names and emails (fixed!)
clients_data = [
  {
    name: "Sarah Chen",
    email: "sarah.chen@gmail.com",
    detailed: true,
    split_type: :"3_day_split",
    focus: "strength_building"
  },
  {
    name: "Marcus Johnson",
    email: "marcus.johnson@yahoo.com",
    detailed: true,
    split_type: :"5_day_split",
    focus: "bodybuilding"
  },
  {
    name: "Emma Rodriguez",
    email: "emma.rodriguez@hotmail.com",
    detailed: false
  },
  {
    name: "David Kim",
    email: "david.kim@outlook.com",
    detailed: false
  },
  {
    name: "Jessica Taylor",
    email: "jessica.taylor@gmail.com",
    detailed: false
  },
  {
    name: "Ryan O'Connor",
    email: "ryan.oconnor@yahoo.com",
    detailed: false
  },
  {
    name: "Priya Patel",
    email: "priya.patel@gmail.com",
    detailed: false
  },
  {
    name: "Carlos Santos",
    email: "carlos.santos@hotmail.com",
    detailed: false
  }
]

clients = []

clients_data.each do |client_data|
  # Skip if email already exists
  if User.exists?(email: client_data[:email])
    puts "  ⚠️  Skipping #{client_data[:name]} - email already exists"
    next
  end

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
  puts "  ✅ Created client: #{client_data[:name]} (#{client_data[:email]})"
end

puts "🏋️ Creating detailed workout data for featured clients..."

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

# Find our detailed clients
sarah = clients.find { |c| c[:data][:name] == "Sarah Chen" }&.dig(:user)
marcus = clients.find { |c| c[:data][:name] == "Marcus Johnson" }&.dig(:user)

if sarah
  puts "  📊 Creating Sarah's workout data..."

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

  # Sarah's recent workouts
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

  create_workout_log(sarah, legs_workout, 14, {
    "Squats (Regular)" => [
      { reps: 8, weight: 80, type: 'working', notes: 'depth was perfect' },
      { reps: 6, weight: 85, type: 'working', notes: 'felt heavy but strong' },
      { reps: 5, weight: 90, type: 'working', notes: 'new PR, very happy!' }
    ]
  }, is_benchmark: true, context: "Legs feeling really strong lately. Been working on mobility and it's paying off.")

  create_workout_log(sarah, push_workout, 7, {
    "Bench Press (Barbell)" => [
      { reps: 8, weight: 62.5, type: 'working', notes: 'progress from last week' },
      { reps: 7, weight: 67.5, type: 'working', notes: 'getting stronger' }
    ]
  })
end

if marcus
  puts "  📊 Creating Marcus's workout data..."

  marcus_split = SplitPlan.create!(
    user: marcus,
    name: "5_day_split",
    split_length: 5
  )

  # 5-day split days
  chest_day = SplitDay.create!(split_plan: marcus_split, day_number: 1, muscle_group: "chest_and_triceps")
  back_day = SplitDay.create!(split_plan: marcus_split, day_number: 2, muscle_group: "back_and_biceps")

  # Marcus workouts
  chest_workout = Workout.create!(split_day: chest_day, name: "Chest & Triceps", muscle_group: "chest_and_triceps")

  create_workout_log(marcus, chest_workout, 16, {
    "Bench Press (Dumbbell)" => [
      { reps: 12, weight: 32.5, type: 'working', notes: 'full range of motion' },
      { reps: 10, weight: 35, type: 'working', notes: 'really squeezed at top' }
    ],
    "Dumbbell Flyes" => [
      { reps: 15, weight: 15, type: 'working', notes: 'slow and controlled' }
    ]
  }, is_benchmark: true, context: "New training block focused on hypertrophy. Higher reps and time under tension.")

  create_workout_log(marcus, chest_workout, 3, {
    "Bench Press (Dumbbell)" => [
      { reps: 12, weight: 35, type: 'working', notes: 'strength is up!' },
      { reps: 11, weight: 37.5, type: 'working', notes: 'beat last week' }
    ]
  })
end

puts ""
puts "✅ Demo data added successfully!"
puts ""
puts "🎬 Demo Login Details:"
puts "📧 Trainer: alex.rivera@fitnesstech.com / DemoPass123!"
puts "👥 Clients created: #{clients.count}"
puts "🏋️  Workout data for Sarah Chen and Marcus Johnson"
puts ""
puts "🎥 Ready for screen recording!"
