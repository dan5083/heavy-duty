puts "🌱 Seeding the database..."

# 🔄 Reset all data
WorkoutLog.destroy_all
Workout.destroy_all
SplitPlan.destroy_all
User.destroy_all

# ✅ Create user
user = User.create!(
  email: "user@example.com",
  password: "zero123456",
  name: "Demo User"
)

# ✅ Create 6-day split plan
split = user.split_plans.create!(
  name: "6-Day Classic Split",
  split_length: 6
)

# ✅ Structured benchmarks — conversational style, exactly 2 set descriptions per exercise
days = [
  [:chest, {
    "Flat Bench Press" => [
      "Started off with eight reps at 70 kilos — moved pretty well.",
      "Second set I pushed six reps at 75 kilos — bit heavier but clean."
    ],
    "Incline Dumbbell Press" => [
      "Hit ten reps with 25 kilo dumbbells to start.",
      "Then went lighter with 20s for an all-out set — managed twelve."
    ],
    "Cable Flys" => [
      "First set was fifteen reps at 15 kilos, kept it smooth.",
      "Second one, same weight — felt that chest burn kick in."
    ],
    "Push-Ups" => [
      "Knocked out twenty push-ups, slow and steady.",
      "Second round — another twenty, burned by the end."
    ]
  }],
  [:back, {
    "Pull-Ups" => [
      "Got through eight bodyweight pull-ups with full range.",
      "Second set, went to failure and cranked out ten."
    ],
    "Barbell Rows" => [
      "Did ten strong reps with 60 kilos, felt good on the back.",
      "Second set, same weight — kept the form tight for another ten."
    ],
    "Lat Pulldown" => [
      "Started with twelve reps at 40 kilos, full stretch at the top.",
      "Second round, same setup — really squeezed each rep."
    ],
    "Seated Row" => [
      "Fifteen reps at 35 kilos on the first set, nice and steady.",
      "Second set, same weight, focused more on the squeeze."
    ]
  }],
  [:legs, {
    "Front Squat" => [
      "Six reps at 80 kilos, kept it deep and solid.",
      "Second set, same weight — legs felt it on the way up."
    ],
    "Leg Press" => [
      "Twelve reps at 120 kilos, full range of motion.",
      "Second set, pushed through another twelve — heavy but clean."
    ],
    "Romanian Deadlift" => [
      "Ten reps with 60 kilos, really stretched the hamstrings.",
      "Second set, same weight — slow on the way down."
    ],
    "Walking Lunges" => [
      "Twenty steps with bodyweight to get started.",
      "Second set, same thing — kept the pace steady."
    ]
  }],
  [:shoulders, {
    "Overhead Press" => [
      "Ten reps at 40 kilos — felt solid overhead.",
      "Second set, went up to 45 kilos and hit eight."
    ],
    "Lateral Raise" => [
      "Fifteen reps using 8 kilo dumbbells — controlled and smooth.",
      "Second round, same weight — arms were on fire by the end."
    ],
    "Rear Delt Fly" => [
      "Twelve reps with 7 kilo dumbbells, really focused on form.",
      "Second set, same weight, bit slower tempo."
    ],
    "Arnold Press" => [
      "Ten reps with 15 kilo dumbbells — good shoulder pump.",
      "Second set, same weight — got another ten in."
    ]
  }],
  [:arms_biceps_and_triceps, {
    "EZ-Bar Curl" => [
      "Twelve reps at 30 kilos — biceps were working hard.",
      "Second round, dropped to 25 kilos for an AMRAP — got fifteen."
    ],
    "Skull Crushers" => [
      "Twelve solid reps with 30 kilos — elbows locked in.",
      "Second set, slowed the tempo a bit, same rep count."
    ],
    "Hammer Curl" => [
      "Ten reps with 12 kilo dumbbells, alternating arms.",
      "Second set, same weight — felt it in the forearms too."
    ],
    "Tricep Dips" => [
      "Fifteen bodyweight dips, nice and deep.",
      "Second round — same rep count, arms shaking by the end."
    ]
  }],
  [:core, {
    "Plank" => [
      "Held a plank for 60 seconds — stayed tight the whole time.",
      "Second set, same thing — abs were shaking near the end."
    ],
    "Russian Twists" => [
      "Thirty total twists with a plate, kept it quick.",
      "Second round — same count, pushed the pace a bit more."
    ],
    "Leg Raises" => [
      "Twenty slow and steady leg raises, back flat on the mat.",
      "Second set — another twenty, kept the control throughout."
    ],
    "Cable Crunch" => [
      "Fifteen reps at 25 kilos, really crunched down hard.",
      "Second set, same weight — made sure to pause at the bottom."
    ]
  }]
]


# ✅ Create split days, workouts, and realistic logs
days.each_with_index do |(muscle, benchmark), i|
  day = split.split_days.create!(
    day_number: i + 1,
    muscle_group: muscle
  )

  workout = day.workouts.create!(
    name: AppConstants::LABELS[muscle], # e.g. "Chest"
    muscle_group: muscle,
    details: benchmark.to_json
  )

  # Slight variation from benchmark for realism
  log_data = benchmark.transform_values do |sets|
    sets.map do |s|
      s.include?("AMRAP") ? s : s.gsub(/\d+/) { |n| n.to_i + 1 } # e.g. 3×10 → 4×10
    end
  end

  workout.workout_logs.create!(
    user: user,
    details: log_data.to_json,
    created_at: Date.today - (i + 1).days
  )
end

puts "✅ Seed complete for #{user.email}"
