class AppConstants
  # Hardcoded user-facing split options (e.g. "3 day split")
# SPLITS constant
SPLITS = {
  :"1_day_split" => [:entire_body],
  :"2_day_split" => [:upper_body, :lower_body],
  :"3_day_split" => [:push_chest_shoulders_triceps, :pull_back_biceps, :legs],
  :"4_day_split" => [:upper_body, :lower_body, :push_chest_shoulders_triceps, :pull_back_biceps],
  :"5_day_split" => [:chest_and_triceps, :back_and_biceps, :legs, :shoulders, :core],
  :"6_day_split" => [:chest, :back, :legs, :shoulders, :arms_biceps_and_triceps, :core],
  :"7_day_split" => [:chest, :back, :legs, :shoulders, :biceps, :triceps, :core],
  :"8_day_split" => [:chest, :back, :quads_and_calves, :shoulders, :hamstrings_and_glutes, :biceps, :triceps, :core],
  :"9_day_split" => [:chest, :back, :quads, :hamstrings, :glutes_and_calves, :shoulders, :biceps, :triceps, :core],
  :"10_day_split" => [
    :chest_pectorals,
    :back_lats_trapezius_rhomboids,
    :shoulders_deltoids,
    :biceps,
    :triceps,
    :legs_quads_and_hamstrings,
    :legs_glutes_and_calves,
    :core_abs_and_obliques,
    :forearms_and_grip_strength,
    :neck_and_mobility_stretching
  ]
}.freeze


  # Symbol-based workout dictionary per muscle group
WORKOUTS = {
  entire_body: [
    "Burpees", "Kettlebell Swings", "Clean and Press", "Snatch",
    "Mountain Climbers", "Turkish Get-Ups", "Thrusters", "Man Makers",
    "Devil's Press", "Bear Crawls", "Farmer's Walks", "Battle Ropes",
    "Box Jump Burpees", "Kettlebell Clean and Jerk", "Sandbag Carries",
    "Medicine Ball Slams", "Tire Flips", "Sled Pushes", "Rope Climbs",
    "Wall Balls", "Rowing Machine", "Assault Bike", "Jump Rope"
  ],

  upper_body: [
    "Pull-Ups", "Push-Ups", "Overhead Press", "Dumbbell Bench Press",
    "Chin-Ups", "Dips", "Handstand Push-Ups", "Pike Push-Ups",
    "Diamond Push-Ups", "Wide-Grip Push-Ups", "Archer Push-Ups",
    "Ring Dips", "Muscle-Ups", "Inverted Rows", "Face Pulls",
    "Arnold Press", "Landmine Press", "Single-Arm Dumbbell Press",
    "Cable Chest Fly", "Seated Cable Row", "T-Bar Row"
  ],

  lower_body: [
    "Squats", "Lunges", "Romanian Deadlifts", "Leg Press",
    "Bulgarian Split Squats", "Goblet Squats", "Front Squats", "Sumo Squats",
    "Jump Squats", "Pistol Squats", "Cossack Squats", "Single-Leg Deadlifts",
    "Walking Lunges", "Reverse Lunges", "Lateral Lunges", "Curtsy Lunges",
    "Step-Ups", "Box Jumps", "Broad Jumps", "Single-Leg Glute Bridge",
    "Wall Sits", "Calf Raises", "Jump Lunges", "Sumo Deadlifts"
  ],

  push_chest_shoulders_triceps: [
    "Bench Press", "Overhead Press", "Tricep Dips", "Incline Dumbbell Press",
    "Close-Grip Bench Press", "Decline Bench Press", "Dumbbell Flyes",
    "Cable Crossover", "Arnold Press", "Lateral Raises", "Front Raises",
    "Tricep Pushdowns", "Overhead Tricep Extension", "Diamond Push-Ups",
    "Pike Push-Ups", "Handstand Push-Ups", "Chest Dips", "Pec Deck",
    "Machine Shoulder Press", "Cable Lateral Raises", "Skull Crushers"
  ],

  pull_back_biceps: [
    "Pull-Ups", "Barbell Rows", "Lat Pulldown", "Barbell Curl",
    "Chin-Ups", "T-Bar Rows", "Seated Cable Rows", "Face Pulls",
    "Hammer Curls", "Preacher Curls", "Cable Curls", "Concentration Curls",
    "21s Bicep Curls", "Reverse Flyes", "Shrugs", "Upright Rows",
    "Single-Arm Dumbbell Rows", "Inverted Rows", "Wide-Grip Pull-Ups",
    "Commando Pull-Ups", "EZ-Bar Curls", "Cable Hammer Curls"
  ],

  legs: [
    "Barbell Squat", "Leg Press", "Romanian Deadlift", "Walking Lunges",
    "Front Squats", "Hack Squats", "Leg Extensions", "Leg Curls",
    "Bulgarian Split Squats", "Goblet Squats", "Sumo Squats", "Jump Squats",
    "Single-Leg Deadlifts", "Stiff-Leg Deadlifts", "Good Mornings",
    "Hip Thrusts", "Glute Bridges", "Step-Ups", "Box Jumps", "Calf Raises",
    "Seated Calf Raises", "Donkey Calf Raises", "Wall Sits", "Lateral Lunges"
  ],

  chest_and_triceps: [
    "Bench Press", "Incline Press", "Cable Flys", "Triceps Pushdown",
    "Close-Grip Bench Press", "Decline Bench Press", "Dumbbell Flyes",
    "Incline Dumbbell Flyes", "Pec Deck", "Cable Crossover", "Chest Dips",
    "Tricep Dips", "Overhead Tricep Extension", "Skull Crushers",
    "Diamond Push-Ups", "JM Press", "California Press", "Tricep Kickbacks",
    "Cable Overhead Extension", "Single-Arm Tricep Extension"
  ],

  back_and_biceps: [
    "Deadlift", "Lat Pulldown", "Barbell Curl", "Seated Row",
    "Pull-Ups", "Chin-Ups", "T-Bar Rows", "Bent-Over Rows", "Face Pulls",
    "Cable Rows", "Single-Arm Rows", "Hammer Curls", "Preacher Curls",
    "Cable Curls", "Concentration Curls", "21s", "Reverse Curls",
    "Wide-Grip Pulldowns", "Close-Grip Pulldowns", "Shrugs", "Reverse Flyes"
  ],

  shoulders: [
    "Overhead Press", "Lateral Raise", "Rear Delt Fly", "Arnold Press",
    "Front Raises", "Upright Rows", "Face Pulls", "Reverse Flyes",
    "Cable Lateral Raises", "Cable Rear Delt Flyes", "Handstand Push-Ups",
    "Pike Push-Ups", "Cuban Press", "High Pulls", "Push Press",
    "Bradford Press", "Lu Raises", "Y-Raises", "T-Raises", "Scarecrows"
  ],

  core: [
    "Plank", "Russian Twists", "Leg Raises", "Cable Crunch",
    "Bicycle Crunches", "Dead Bug", "Bird Dog", "Side Plank",
    "Mountain Climbers", "Hollow Body Hold", "V-Ups", "Sit-Ups",
    "Hanging Leg Raises", "Knee Raises", "Wood Chops", "Pallof Press",
    "Ab Wheel Rollouts", "Dragon Flags", "L-Sits", "Flutter Kicks",
    "Scissors", "Bear Crawls", "Turkish Get-Ups", "Farmer's Walks"
  ],

  chest: [
    "Flat Bench Press", "Incline Dumbbell Press", "Chest Fly Machine", "Push-Ups",
    "Incline Barbell Press", "Decline Bench Press", "Dumbbell Flyes",
    "Cable Crossover", "Pec Deck", "Chest Dips", "Wide-Grip Push-Ups",
    "Diamond Push-Ups", "Incline Push-Ups", "Decline Push-Ups",
    "Single-Arm Dumbbell Press", "Landmine Press", "Squeeze Press",
    "Hex Press", "Svend Press", "Cable Flyes", "Pullovers"
  ],

  back: [
    "Pull-Ups", "Barbell Rows", "Seated Cable Row", "Lat Pulldown",
    "Chin-Ups", "T-Bar Rows", "Single-Arm Rows", "Face Pulls",
    "Wide-Grip Pulldowns", "Close-Grip Pulldowns", "Inverted Rows",
    "Chest-Supported Rows", "Landmine Rows", "Reverse Flyes", "Shrugs",
    "High Pulls", "Good Mornings", "Hyperextensions", "Superman",
    "Prone Y-T-W", "Cable Rows", "Machine Rows"
  ],

  arms_biceps_and_triceps: [
    "Barbell Curl", "Hammer Curl", "Tricep Dips", "Skull Crushers",
    "Close-Grip Bench Press", "Preacher Curls", "Concentration Curls",
    "Cable Curls", "Overhead Tricep Extension", "Tricep Pushdowns",
    "21s", "Spider Curls", "Drag Curls", "Zottman Curls", "Cable Hammer Curls",
    "JM Press", "California Press", "Tricep Kickbacks", "Diamond Push-Ups",
    "Chin-Ups", "Dips", "EZ-Bar Curls", "Reverse Curls"
  ],

  quads_and_calves: [
    "Leg Press", "Front Squat", "Seated Calf Raise", "Walking Lunges",
    "Leg Extensions", "Hack Squats", "Bulgarian Split Squats", "Jump Squats",
    "Goblet Squats", "Step-Ups", "Box Jumps", "Standing Calf Raises",
    "Donkey Calf Raises", "Single-Leg Calf Raises", "Calf Press on Leg Press",
    "Wall Sits", "Sissy Squats", "Cyclist Squats", "Lateral Lunges",
    "Jump Lunges", "Pogo Jumps", "Single-Leg Leg Press"
  ],

  hamstrings_and_glutes: [
    "Romanian Deadlifts", "Hip Thrusts", "Glute Bridge", "Cable Kickbacks",
    "Good Mornings", "Stiff-Leg Deadlifts", "Single-Leg Deadlifts",
    "Leg Curls", "Nordic Curls", "Glute Ham Raises", "Reverse Hypers",
    "Bulgarian Split Squats", "Step-Ups", "Single-Leg Hip Thrusts",
    "Clamshells", "Fire Hydrants", "Donkey Kicks", "Sumo Deadlifts",
    "Curtsy Lunges", "Lateral Lunges", "Monster Walks", "Frog Pumps"
  ],

  biceps: [
    "Dumbbell Curl", "EZ-Bar Curl", "Concentration Curl", "Preacher Curl",
    "Barbell Curl", "Hammer Curl", "Cable Curl", "21s", "Spider Curls",
    "Drag Curls", "Zottman Curls", "Reverse Curls", "Cable Hammer Curls",
    "Incline Dumbbell Curls", "Seated Dumbbell Curls", "Cross-Body Curls",
    "Wide-Grip Curls", "Close-Grip Curls", "Chin-Ups", "Isometric Holds"
  ],

  triceps: [
    "Tricep Rope Pushdown", "Overhead Dumbbell Extension", "Close-Grip Bench Press",
    "Tricep Dips", "Skull Crushers", "JM Press", "California Press",
    "Diamond Push-Ups", "Tricep Kickbacks", "Cable Overhead Extension",
    "Single-Arm Tricep Extension", "Tate Press", "Board Press",
    "French Press", "Lying Tricep Extension", "Seated Tricep Press",
    "Machine Tricep Extension", "Reverse-Grip Pushdowns"
  ],

  quads: [
    "Front Squat", "Bulgarian Split Squat", "Leg Extension", "Walking Lunges",
    "Hack Squats", "Leg Press", "Goblet Squats", "Jump Squats", "Step-Ups",
    "Box Jumps", "Wall Sits", "Sissy Squats", "Cyclist Squats",
    "Single-Leg Leg Press", "Lateral Lunges", "Jump Lunges", "Reverse Lunges",
    "High Step-Ups", "Pulse Squats", "Narrow Squats", "Wide Squats"
  ],

  hamstrings: [
    "Romanian Deadlifts", "Leg Curl Machine", "Good Mornings",
    "Stiff-Leg Deadlifts", "Single-Leg Deadlifts", "Nordic Curls",
    "Glute Ham Raises", "Lying Leg Curls", "Seated Leg Curls",
    "Standing Leg Curls", "Cable Pull-Throughs", "Kettlebell Swings",
    "Reverse Hypers", "Stability Ball Leg Curls", "Slider Leg Curls"
  ],

  glutes_and_calves: [
    "Hip Thrusts", "Cable Kickbacks", "Standing Calf Raise", "Donkey Calf Raise",
    "Glute Bridges", "Single-Leg Hip Thrusts", "Clamshells", "Fire Hydrants",
    "Monster Walks", "Lateral Band Walks", "Curtsy Lunges", "Step-Ups",
    "Seated Calf Raises", "Single-Leg Calf Raises", "Calf Press on Leg Press",
    "Jump Squats", "Frog Pumps", "Reverse Lunges", "Sumo Squats",
    "Wall Calf Raises", "Farmer's Walk on Toes"
  ],

  chest_pectorals: [
    "Flat Bench Press", "Pec Deck Machine", "Cable Crossover", "Incline Dumbbell Press",
    "Incline Barbell Press", "Decline Bench Press", "Dumbbell Flyes",
    "Incline Dumbbell Flyes", "Decline Dumbbell Flyes", "Chest Dips",
    "Push-Ups", "Wide-Grip Push-Ups", "Diamond Push-Ups", "Incline Push-Ups",
    "Decline Push-Ups", "Landmine Press", "Squeeze Press", "Hex Press",
    "Svend Press", "Single-Arm Dumbbell Press", "Pullovers"
  ],

  back_lats_trapezius_rhomboids: [
    "Deadlift", "Lat Pulldown", "Face Pulls", "T-Bar Row",
    "Pull-Ups", "Chin-Ups", "Barbell Rows", "Seated Cable Rows",
    "Single-Arm Rows", "Wide-Grip Pulldowns", "Close-Grip Pulldowns",
    "Inverted Rows", "Chest-Supported Rows", "Landmine Rows", "Shrugs",
    "Reverse Flyes", "High Pulls", "Prone Y-T-W", "Superman",
    "Hyperextensions", "Good Mornings", "Cable Rows", "Machine Rows"
  ],

  shoulders_deltoids: [
    "Overhead Press", "Lateral Raises", "Reverse Fly", "Upright Row",
    "Arnold Press", "Front Raises", "Face Pulls", "Cable Lateral Raises",
    "Cable Rear Delt Flyes", "Handstand Push-Ups", "Pike Push-Ups",
    "Cuban Press", "High Pulls", "Push Press", "Bradford Press",
    "Lu Raises", "Y-Raises", "T-Raises", "Scarecrows", "Band Pull-Aparts",
    "Wall Handstand", "Seated Dumbbell Press"
  ],

  legs_quads_and_hamstrings: [
    "Barbell Squat", "Leg Press", "Romanian Deadlift", "Walking Lunges",
    "Front Squats", "Hack Squats", "Leg Extensions", "Leg Curls",
    "Bulgarian Split Squats", "Good Mornings", "Stiff-Leg Deadlifts",
    "Single-Leg Deadlifts", "Jump Squats", "Step-Ups", "Box Jumps",
    "Goblet Squats", "Sumo Squats", "Nordic Curls", "Glute Ham Raises",
    "Wall Sits", "Lateral Lunges", "Reverse Lunges", "Cyclist Squats"
  ],

  legs_glutes_and_calves: [
    "Hip Thrusts", "Donkey Calf Raise", "Cable Kickbacks", "Step-Ups",
    "Glute Bridges", "Single-Leg Hip Thrusts", "Clamshells", "Fire Hydrants",
    "Monster Walks", "Curtsy Lunges", "Standing Calf Raises", "Seated Calf Raises",
    "Single-Leg Calf Raises", "Calf Press on Leg Press", "Jump Squats",
    "Frog Pumps", "Lateral Band Walks", "Sumo Squats", "Wall Calf Raises",
    "Farmer's Walk on Toes", "Reverse Lunges", "Bulgarian Split Squats"
  ],

  core_abs_and_obliques: [
    "Bicycle Crunches", "Plank", "Side Plank", "Hanging Leg Raises",
    "Russian Twists", "Dead Bug", "Bird Dog", "Mountain Climbers",
    "V-Ups", "Sit-Ups", "Leg Raises", "Knee Raises", "Wood Chops",
    "Pallof Press", "Ab Wheel Rollouts", "Dragon Flags", "L-Sits",
    "Flutter Kicks", "Scissors", "Hollow Body Hold", "Bear Crawls",
    "Turkish Get-Ups", "Cable Crunches", "Reverse Crunches"
  ],

  forearms_and_grip_strength: [
    "Farmer's Walk", "Wrist Curls", "Dead Hangs", "Reverse Curls",
    "Reverse Wrist Curls", "Plate Pinches", "Grip Crushers", "Fat Bar Holds",
    "Towel Pull-Ups", "Rope Climbing", "Hammer Curls", "Zottman Curls",
    "Finger Extensions", "Rice Bucket Training", "Stress Ball Squeezes",
    "Barbell Holds", "Dumbbell Holds", "Cable Wrist Curls", "Wrist Roller",
    "Finger Walks", "Rock Climbing", "Kettlebell Bottoms-Up Press"
  ],

  neck_and_mobility_stretching: [
    "Neck Flexion", "Neck Extension", "Foam Rolling", "Yoga Poses",
    "Neck Lateral Flexion", "Neck Rotation", "Cat-Cow Stretch",
    "Child's Pose", "Downward Dog", "Hip Circles", "Leg Swings",
    "Arm Circles", "Shoulder Rolls", "Chest Stretch", "Hip Flexor Stretch",
    "Hamstring Stretch", "Calf Stretch", "Quad Stretch", "IT Band Stretch",
    "Pigeon Pose", "Cobra Stretch", "Seated Spinal Twist", "Thread the Needle"
  ]
}.freeze

  # Recovery cycle durations (in days) per muscle group
  TRAINING_CYCLE = {
  entire_body: 10,
  upper_body: 6,
  lower_body: 8,
  push_chest_shoulders_triceps: 7,
  pull_back_biceps: 7,
  legs: 9,
  chest_and_triceps: 6,
  back_and_biceps: 6,
  shoulders: 5,
  core: 3,
  chest: 6,
  back: 7,
  arms_biceps_and_triceps: 4,
  quads_and_calves: 9,
  hamstrings_and_glutes: 9,
  biceps: 3,
  triceps: 3,
  quads: 8,
  hamstrings: 8,
  glutes_and_calves: 10,
  chest_pectorals: 6,
  back_lats_trapezius_rhomboids: 7,
  shoulders_deltoids: 5,
  legs_quads_and_hamstrings: 9,
  legs_glutes_and_calves: 10,
  core_abs_and_obliques: 3,
  forearms_and_grip_strength: 2,
  neck_and_mobility_stretching: 4
  }.freeze

  # Mapping from internal symbols to display strings
  LABELS = {
  entire_body: "Entire Body",
  upper_body: "Upper Body",
  lower_body: "Lower Body",
  push_chest_shoulders_triceps: "Push (Chest, Shoulders, Triceps)",
  pull_back_biceps: "Pull (Back, Biceps)",
  legs: "Legs",
  chest_and_triceps: "Chest & Triceps",
  back_and_biceps: "Back & Biceps",
  shoulders: "Shoulders",
  core: "Core",
  chest: "Chest",
  back: "Back",
  arms_biceps_and_triceps: "Arms (Biceps & Triceps)",
  quads_and_calves: "Quads & Calves",
  hamstrings_and_glutes: "Hamstrings & Glutes",
  biceps: "Biceps",
  triceps: "Triceps",
  quads: "Quads",
  hamstrings: "Hamstrings",
  glutes_and_calves: "Glutes & Calves",
  chest_pectorals: "Chest (Pectorals)",
  back_lats_trapezius_rhomboids: "Back (Lats, Trapezius, Rhomboids)",
  shoulders_deltoids: "Shoulders (Deltoids)",
  legs_quads_and_hamstrings: "Legs - Quads & Hamstrings",
  legs_glutes_and_calves: "Legs - Glutes & Calves",
  core_abs_and_obliques: "Core (Abs & Obliques)",
  forearms_and_grip_strength: "Forearms & Grip Strength",
  neck_and_mobility_stretching: "Neck & Mobility/Stretching",
  :"1_day_split" => "1 Day Split",
  :"2_day_split" => "2 Day Split",
  :"3_day_split" => "3 Day Split",
  :"4_day_split" => "4 Day Split",
  :"5_day_split" => "5 Day Split",
  :"6_day_split" => "6 Day Split",
  :"7_day_split" => "7 Day Split",
  :"8_day_split" => "8 Day Split",
  :"9_day_split" => "9 Day Split",
  :"10_day_split" => "10 Day Split"
  }.freeze

  # Utility methods
  def self.label_for(symbol)
    LABELS[symbol] || symbol.to_s.humanize
  end

  def self.all_muscle_groups
    WORKOUTS.keys
  end

  def self.recovery_days_for(muscle)
    TRAINING_CYCLE[muscle] || 5
  end
end
