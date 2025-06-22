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
    "Assault Bike", "Battle Ropes", "Bear Crawls", "Box Jumps", "Box Jump Burpees",
    "Burpees", "Clean and Press", "Deadlifts", "Devil's Press", "Farmer's Walks",
    "Jump Rope", "Jumping Jacks", "Kettlebell Clean and Jerk", "Kettlebell Swings",
    "Man Makers", "Medicine Ball Slams", "Mountain Climbers", "Push-up to T",
    "Rope Climbs", "Rowing Machine", "Sandbag Carries", "Sled Pushes", "Snatch",
    "Squat to Press", "Star Jumps", "Swimming", "Thrusters", "Tire Flips",
    "Turkish Get-Ups", "Wall Balls", "Wood Chops"
  ],


  upper_body: [
    "Arnold Press", "Bench Press (Barbell)", "Bench Press (Close-Grip)",
    "Bench Press (Decline)", "Bench Press (Dumbbell)", "Bench Press (Incline)",
    "Cable Chest Fly", "Chin-Ups", "Curls (Barbell)", "Curls (Cable)",
    "Curls (Concentration)", "Curls (Dumbbell)", "Curls (Hammer)", "Curls (Preacher)",
    "Dips", "Dumbbell Flyes", "Face Pulls", "Handstand Push-Ups", "Inverted Rows",
    "Landmine Press", "Lat Pulldown", "Lateral Raises", "Military Press",
    "Muscle-Ups", "Overhead Press", "Overhead Tricep Extension", "Pec Deck",
    "Pull-Ups", "Pull-Ups (Wide-Grip)", "Push-Ups (Archer)", "Push-Ups (Diamond)",
    "Push-Ups (Incline)", "Push-Ups (Pike)", "Push-Ups (Wide-Grip)", "Ring Dips",
    "Rows (Barbell)", "Rows (Cable)", "Rows (Dumbbell)", "Rows (Single-Arm)",
    "Rows (T-Bar)", "Seated Cable Row", "Seated Dumbbell Press", "Shrugs",
    "Skull Crushers", "Tricep Dips", "Tricep Pushdowns", "Upright Rows"
  ],

  lower_body: [
    "Box Jumps", "Broad Jumps", "Bulgarian Split Squats", "Calf Raises (Donkey)",
    "Calf Raises (Seated)", "Calf Raises (Single-Leg)", "Calf Raises (Standing)",
    "Deadlifts", "Deadlifts (Romanian)", "Deadlifts (Single-Leg)",
    "Deadlifts (Stiff-Leg)", "Deadlifts (Sumo)", "Glute Bridges",
    "Glute Bridges (Single-Leg)", "Good Mornings", "Hack Squats", "Hip Thrusts",
    "Hip Thrusts (Single-Leg)", "Leg Curls", "Leg Extensions", "Leg Press",
    "Lunges (Curtsy)", "Lunges (Jump)", "Lunges (Lateral)", "Lunges (Reverse)",
    "Lunges (Walking)", "Nordic Curls", "Squats (Cossack)", "Squats (Front)",
    "Squats (Goblet)", "Squats (Jump)", "Squats (Pistol)", "Squats (Regular)",
    "Squats (Sumo)", "Step-Ups", "Wall Sits"
  ],

  push_chest_shoulders_triceps: [
    "Arnold Press", "Bench Press (Close-Grip)", "Bench Press (Decline)",
    "Bench Press (Dumbbell)", "Bench Press (Incline)", "Bench Press (Regular)",
    "Cable Crossover", "Cable Lateral Raises", "Cable Overhead Tricep Extension",
    "Chest Dips", "Dips", "Dumbbell Flyes", "Dumbbell Flyes (Incline)",
    "Dumbbell Shoulder Press", "Front Raises", "Handstand Push-Ups", "JM Press",
    "Landmine Press", "Lateral Raises", "Machine Shoulder Press", "Military Press",
    "Overhead Press", "Overhead Tricep Extension", "Pec Deck", "Push Press",
    "Push-Ups (Diamond)", "Push-Ups (Pike)", "Push-Ups (Regular)",
    "Push-Ups (Wide-Grip)", "Reverse Flyes", "Seated Dumbbell Press",
    "Skull Crushers", "Tricep Dips", "Tricep Kickbacks", "Tricep Pushdowns",
    "Upright Rows"
  ],

  pull_back_biceps: [
    "Chest-Supported Rows", "Chin-Ups", "Commando Pull-Ups",
    "Curls (21s Bicep)", "Curls (Barbell)", "Curls (Cable)", "Curls (Cable Hammer)",
    "Curls (Concentration)", "Curls (EZ-Bar)", "Curls (Hammer)",
    "Curls (Incline Dumbbell)", "Curls (Preacher)", "Curls (Reverse)",
    "Deadlifts", "Face Pulls", "High Pulls", "Inverted Rows",
    "Pulldowns (Close-Grip)", "Pulldowns (Lat)", "Pulldowns (Wide-Grip)",
    "Pull-Ups", "Pull-Ups (Wide-Grip)", "Reverse Flyes",
    "Rows (Barbell)", "Rows (Cable)", "Rows (Landmine)", "Rows (Machine)",
    "Rows (Seated Cable)", "Rows (Single-Arm Dumbbell)", "Rows (T-Bar)",
    "Shrugs", "Upright Rows"
  ],

  legs: [
    "Box Jumps", "Broad Jumps", "Bulgarian Split Squats", "Calf Raises (Donkey)",
    "Calf Raises (Seated)", "Calf Raises (Single-Leg)", "Calf Raises (Standing)",
    "Deadlifts (Romanian)", "Deadlifts (Single-Leg)", "Deadlifts (Stiff-Leg)",
    "Deadlifts (Sumo)", "Glute Bridges", "Glute Ham Raises", "Good Mornings",
    "Hack Squats", "Hip Thrusts", "Hip Thrusts (Single-Leg)", "Leg Curls",
    "Leg Extensions", "Leg Press", "Lunges (Curtsy)", "Lunges (Jump)",
    "Lunges (Lateral)", "Lunges (Reverse)", "Lunges (Walking)", "Nordic Curls",
    "Squats (Barbell)", "Squats (Cossack)", "Squats (Cyclist)", "Squats (Front)",
    "Squats (Goblet)", "Squats (Jump)", "Squats (Pistol)", "Squats (Sissy)",
    "Squats (Sumo)", "Step-Ups", "Wall Sits"
  ],

  chest_and_triceps: [
    "Bench Press (Close-Grip)", "Bench Press (Decline)", "Bench Press (Incline)",
    "Bench Press (Regular)", "Cable Crossover", "Cable Flyes", "Cable Overhead Extension",
    "California Press", "Chest Dips", "Dips (Tricep)", "Dumbbell Flyes",
    "Dumbbell Flyes (Incline)", "Extensions (Overhead Tricep)", "Extensions (Single-Arm Tricep)",
    "JM Press", "Pec Deck", "Push-Ups (Diamond)", "Push-Ups (Regular)",
    "Skull Crushers", "Tricep Kickbacks", "Tricep Pushdowns"
  ],

  back_and_biceps: [
    "Bent-Over Rows", "Chin-Ups", "Curls (21s)", "Curls (Barbell)", "Curls (Cable)",
    "Curls (Concentration)", "Curls (EZ-Bar)", "Curls (Hammer)", "Curls (Preacher)",
    "Curls (Reverse)", "Deadlifts", "Face Pulls", "High Pulls", "Inverted Rows",
    "Lat Pulldown", "Pull-Ups", "Pull-Ups (Wide-Grip)", "Pulldowns (Close-Grip)",
    "Pulldowns (Wide-Grip)", "Reverse Flyes", "Rows (Barbell)", "Rows (Cable)",
    "Rows (Chest-Supported)", "Rows (Landmine)", "Rows (Machine)", "Rows (Seated Cable)",
    "Rows (Single-Arm)", "Rows (T-Bar)", "Shrugs"
  ],

  shoulders: [
    "Arnold Press", "Bradford Press", "Cable Lateral Raises", "Cable Rear Delt Flyes",
    "Cuban Press", "Face Pulls", "Front Raises", "Handstand Push-Ups",
    "Hercules Hold", "High Pulls", "Lateral Raises", "Lu Raises", "Military Press",
    "Overhead Press", "Pike Push-Ups", "Press (Push)", "Press (Seated Dumbbell)",
    "Raises (Front)", "Raises (Lateral)", "Raises (T-)", "Raises (Y-)",
    "Rear Delt Flyes", "Reverse Flyes", "Scarecrows", "Shrugs",
    "Upright Rows"
  ],

  core: [
    "Ab Crunch Machine", "Ab Wheel Rollouts", "Bear Crawls", "Bicycle Crunches",
    "Bird Dog", "Cable Crunches", "Captain's Chair", "Crunches (Bicycle)",
    "Crunches (Cable)", "Crunches (Machine)", "Crunches (Oblique)",
    "Crunches (Regular)", "Crunches (Reverse)", "Dead Bug", "Decline Sit-Ups",
    "Dragon Flags", "Farmer's Walks", "Flutter Kicks", "Hanging Leg Raises",
    "Hollow Body Hold", "Knee Raises", "L-Sits", "Leg Press Crunches",
    "Leg Raises", "Mountain Climbers", "Pallof Press", "Planks (Regular)",
    "Planks (Side)", "Roman Chair Sit-Ups", "Russian Twists", "Scissors",
    "Sit-Ups", "Torso Rotation Machine", "Turkish Get-Ups", "V-Ups", "Wood Chops"
  ],

  chest: [
    "Bench Press (Barbell)", "Bench Press (Decline)", "Bench Press (Dumbbell)",
    "Bench Press (Incline)", "Bench Press (Smith Machine)", "Cable Crossover",
    "Chest Dips", "Chest Fly Machine", "Chest Press Machine", "Chest Press Machine (Decline)",
    "Chest Press Machine (Hammer Strength)", "Chest Press Machine (Incline)", "Dips",
    "Flyes (Cable)", "Flyes (Cable High to Low)", "Flyes (Cable Low to High)",
    "Flyes (Dumbbell)", "Flyes (Dumbbell Decline)", "Flyes (Dumbbell Incline)",
    "Hex Press", "Landmine Press", "Pec Deck", "Pullovers",
    "Push-Ups (Decline)", "Push-Ups (Diamond)", "Push-Ups (Incline)",
    "Push-Ups (Regular)", "Push-Ups (Wide-Grip)", "Squeeze Press", "Svend Press"
  ],

  back: [
    "Assisted Pull-Up Machine", "Cable Rows", "Chin-Ups", "Deadlifts",
    "Face Pulls", "Good Mornings", "High Pulls", "Hyperextensions",
    "Inverted Rows", "Lat Pulldown Machine", "Low Rows (Cable)",
    "Prone Y-T-W", "Pull-Ups", "Pull-Ups (Assisted)", "Pull-Ups (Wide-Grip)",
    "Pulldowns (Close-Grip)", "Pulldowns (Lat)", "Pulldowns (Reverse Grip)",
    "Pulldowns (Wide-Grip)", "Reverse Flyes", "Rows (Barbell)",
    "Rows (Cable)", "Rows (Chest-Supported)", "Rows (Hammer Strength)",
    "Rows (Landmine)", "Rows (Low Cable)", "Rows (Machine)",
    "Rows (Seated Cable)", "Rows (Single-Arm Dumbbell)", "Rows (T-Bar)",
    "Seated Cable Row Machine", "Shrugs", "Superman", "T-Bar Row Machine"
  ],

  arms_biceps_and_triceps: [
    "Bench Press (Close-Grip)", "California Press", "Chin-Ups",
    "Curls (21s)", "Curls (Barbell)", "Curls (Cable)", "Curls (Cable Hammer)",
    "Curls (Concentration)", "Curls (Cross-Body)", "Curls (Drag)", "Curls (EZ-Bar)",
    "Curls (Hammer)", "Curls (Incline Dumbbell)", "Curls (Machine)", "Curls (Preacher)",
    "Curls (Reverse)", "Curls (Spider)", "Curls (Zottman)", "Diamond Push-Ups",
    "Dips", "Dips (Tricep)", "Extensions (Cable Overhead)", "Extensions (Lying Tricep)",
    "Extensions (Machine Tricep)", "Extensions (Overhead Tricep)", "Extensions (Single-Arm Tricep)",
    "JM Press", "Preacher Curl Machine", "Pushdowns (Tricep)", "Pushdowns (Tricep Rope)",
    "Pushdowns (Tricep V-Bar)", "Skull Crushers", "Tricep Kickbacks"
  ],

  quads_and_calves: [
    "Box Jumps", "Bulgarian Split Squats", "Calf Press (Leg Press Machine)",
    "Calf Raises (Donkey)", "Calf Raises (Machine)", "Calf Raises (Seated)",
    "Calf Raises (Single-Leg)", "Calf Raises (Standing)", "Calf Raises (Wall)",
    "Cyclist Squats", "Front Squats", "Goblet Squats", "Hack Squats",
    "Jump Lunges", "Jump Squats", "Lateral Lunges", "Leg Extensions",
    "Leg Press", "Leg Press (Single-Leg)", "Lunges (Jump)", "Lunges (Lateral)",
    "Lunges (Reverse)", "Lunges (Walking)", "Pogo Jumps", "Pulse Squats",
    "Sissy Squats", "Squats (Bulgarian Split)", "Squats (Cyclist)", "Squats (Front)",
    "Squats (Goblet)", "Squats (Hack)", "Squats (Jump)", "Squats (Narrow)",
    "Squats (Pulse)", "Squats (Wide)", "Step-Ups", "Step-Ups (High)",
    "Wall Sits"
  ],

  hamstrings_and_glutes: [
    "Bulgarian Split Squats", "Cable Kickbacks", "Cable Pull-Throughs",
    "Clamshells", "Curtsy Lunges", "Deadlifts (Romanian)", "Deadlifts (Single-Leg)",
    "Deadlifts (Stiff-Leg)", "Deadlifts (Sumo)", "Donkey Kicks", "Fire Hydrants",
    "Frog Pumps", "Glute Bridges", "Glute Bridges (Single-Leg)", "Glute Ham Raises",
    "Glute Ham Raise Machine", "Good Mornings", "Hip Thrusts", "Hip Thrusts (Machine)",
    "Hip Thrusts (Single-Leg)", "Kettlebell Swings", "Lateral Band Walks",
    "Lateral Lunges", "Leg Curls (Lying)", "Leg Curls (Machine)", "Leg Curls (Nordic)",
    "Leg Curls (Seated)", "Leg Curls (Slider)", "Leg Curls (Stability Ball)",
    "Leg Curls (Standing)", "Monster Walks", "Reverse Hypers", "Reverse Lunges",
    "Step-Ups"
  ],

  biceps: [
    "Bicep Curl Machine", "Cable Curls", "Chin-Ups", "Curls (21s)",
    "Curls (Barbell)", "Curls (Cable)", "Curls (Cable Hammer)", "Curls (Concentration)",
    "Curls (Cross-Body)", "Curls (Drag)", "Curls (Dumbbell)", "Curls (EZ-Bar)",
    "Curls (Hammer)", "Curls (Incline Dumbbell)", "Curls (Machine)", "Curls (Preacher)",
    "Curls (Reverse)", "Curls (Seated Dumbbell)", "Curls (Spider)", "Curls (Wide-Grip)",
    "Curls (Zottman)", "Hammer Curls", "Isometric Holds", "Preacher Curl Machine"
  ],

  triceps: [
    "Bench Press (Close-Grip)", "Board Press", "California Press",
    "Diamond Push-Ups", "Dips", "Dips (Tricep)", "Extensions (Cable Overhead)",
    "Extensions (Dumbbell Overhead)", "Extensions (Lying Tricep)", "Extensions (Machine Tricep)",
    "Extensions (Seated Tricep)", "Extensions (Single-Arm Tricep)", "French Press",
    "JM Press", "Pushdowns (Reverse-Grip)", "Pushdowns (Tricep)", "Pushdowns (Tricep Rope)",
    "Pushdowns (Tricep V-Bar)", "Skull Crushers", "Tate Press", "Tricep Dip Machine",
    "Tricep Kickbacks"
  ],

  quads: [
    "Box Jumps", "Bulgarian Split Squats", "Cyclist Squats", "Front Squats",
    "Goblet Squats", "Hack Squats", "Jump Lunges", "Jump Squats",
    "Lateral Lunges", "Leg Extensions", "Leg Press", "Leg Press (Single-Leg)",
    "Lunges (Jump)", "Lunges (Lateral)", "Lunges (Reverse)", "Lunges (Walking)",
    "Pulse Squats", "Sissy Squats", "Squats (Bulgarian Split)", "Squats (Cyclist)",
    "Squats (Front)", "Squats (Goblet)", "Squats (Hack)", "Squats (Jump)",
    "Squats (Narrow)", "Squats (Pulse)", "Squats (Wide)", "Step-Ups",
    "Step-Ups (High)", "Wall Sits"
  ],

  hamstrings: [
    "Cable Pull-Throughs", "Deadlifts (Romanian)", "Deadlifts (Single-Leg)",
    "Deadlifts (Stiff-Leg)", "Glute Ham Raises", "Good Mornings", "Kettlebell Swings",
    "Leg Curls (Lying)", "Leg Curls (Machine)", "Leg Curls (Nordic)",
    "Leg Curls (Seated)", "Leg Curls (Slider)", "Leg Curls (Stability Ball)",
    "Leg Curls (Standing)", "Reverse Hypers"
  ],

  glutes_and_calves: [
    "Cable Kickbacks", "Calf Press (Leg Press)", "Calf Raises (Donkey)",
    "Calf Raises (Seated)", "Calf Raises (Single-Leg)", "Calf Raises (Standing)",
    "Calf Raises (Wall)", "Clamshells", "Curtsy Lunges", "Farmer's Walk on Toes",
    "Fire Hydrants", "Frog Pumps", "Glute Bridges", "Hip Thrusts",
    "Hip Thrusts (Single-Leg)", "Jump Squats", "Lateral Band Walks",
    "Monster Walks", "Reverse Lunges", "Step-Ups", "Sumo Squats"
  ],

  chest_pectorals: [
    "Bench Press (Decline)", "Bench Press (Flat)", "Bench Press (Incline Barbell)",
    "Cable Crossover", "Chest Dips", "Dips", "Flyes (Decline Dumbbell)",
    "Flyes (Dumbbell)", "Flyes (Incline Dumbbell)", "Hex Press", "Incline Dumbbell Press",
    "Landmine Press", "Pec Deck Machine", "Press (Single-Arm Dumbbell)", "Pullovers",
    "Push-Ups (Decline)", "Push-Ups (Diamond)", "Push-Ups (Incline)",
    "Push-Ups (Regular)", "Push-Ups (Wide-Grip)", "Squeeze Press", "Svend Press"
  ],

  back_lats_trapezius_rhomboids: [
    "Barbell Rows", "Cable Rows", "Chest-Supported Rows", "Chin-Ups",
    "Deadlifts", "Face Pulls", "Good Mornings", "High Pulls", "Hyperextensions",
    "Inverted Rows", "Landmine Rows", "Machine Rows", "Prone Y-T-W",
    "Pull-Ups", "Pull-Ups (Wide-Grip)", "Pulldowns (Close-Grip)", "Pulldowns (Lat)",
    "Pulldowns (Wide-Grip)", "Reverse Flyes", "Rows (Barbell)", "Rows (Cable)",
    "Rows (Chest-Supported)", "Rows (Landmine)", "Rows (Machine)",
    "Rows (Seated Cable)", "Rows (Single-Arm)", "Rows (T-Bar)", "Shrugs", "Superman"
  ],

  shoulders_deltoids: [
    "Arnold Press", "Band Pull-Aparts", "Bradford Press", "Cable Lateral Raises",
    "Cable Rear Delt Flyes", "Cuban Press", "Face Pulls", "Front Raises",
    "Handstand Push-Ups", "High Pulls", "Lateral Raises", "Lu Raises",
    "Overhead Press", "Pike Push-Ups", "Press (Push)", "Press (Seated Dumbbell)",
    "Raises (Front)", "Raises (Lateral)", "Raises (Lu)", "Raises (T-)",
    "Raises (Y-)", "Reverse Flyes", "Scarecrows", "Upright Rows", "Wall Handstand"
  ],

  legs_quads_and_hamstrings: [
    "Box Jumps", "Bulgarian Split Squats", "Cyclist Squats", "Deadlifts (Romanian)",
    "Deadlifts (Single-Leg)", "Deadlifts (Stiff-Leg)", "Front Squats", "Glute Ham Raises",
    "Goblet Squats", "Good Mornings", "Hack Squats", "Jump Squats", "Leg Curls",
    "Leg Extensions", "Leg Press", "Lunges (Lateral)", "Lunges (Reverse)",
    "Lunges (Walking)", "Nordic Curls", "Squats (Barbell)", "Squats (Bulgarian Split)",
    "Squats (Cyclist)", "Squats (Front)", "Squats (Goblet)", "Squats (Jump)",
    "Squats (Sumo)", "Step-Ups", "Wall Sits"
  ],

  legs_glutes_and_calves: [
    "Bulgarian Split Squats", "Cable Kickbacks", "Calf Press (Leg Press)",
    "Calf Raises (Donkey)", "Calf Raises (Seated)", "Calf Raises (Single-Leg)",
    "Calf Raises (Standing)", "Calf Raises (Wall)", "Clamshells", "Curtsy Lunges",
    "Farmer's Walk on Toes", "Fire Hydrants", "Frog Pumps", "Glute Bridges",
    "Hip Thrusts", "Hip Thrusts (Single-Leg)", "Jump Squats", "Lateral Band Walks",
    "Monster Walks", "Reverse Lunges", "Step-Ups", "Sumo Squats"
  ],

  core_abs_and_obliques: [
    "Ab Wheel Rollouts", "Bear Crawls", "Bicycle Crunches", "Bird Dog",
    "Cable Crunches", "Crunches (Bicycle)", "Crunches (Cable)", "Crunches (Reverse)",
    "Dead Bug", "Dragon Flags", "Flutter Kicks", "Hanging Leg Raises",
    "Hollow Body Hold", "Knee Raises", "L-Sits", "Leg Raises", "Mountain Climbers",
    "Pallof Press", "Planks (Regular)", "Planks (Side)", "Russian Twists",
    "Scissors", "Sit-Ups", "Turkish Get-Ups", "V-Ups", "Wood Chops"
  ],

  forearms_and_grip_strength: [
    "Barbell Holds", "Cable Wrist Curls", "Curls (Hammer)", "Curls (Reverse)",
    "Curls (Wrist)", "Curls (Zottman)", "Dead Hangs", "Dumbbell Holds",
    "Farmer's Walk", "Fat Bar Holds", "Finger Extensions", "Finger Walks",
    "Grip Crushers", "Kettlebell Bottoms-Up Press", "Plate Pinches",
    "Pull-Ups (Towel)", "Reverse Wrist Curls", "Rice Bucket Training",
    "Rock Climbing", "Rope Climbing", "Stress Ball Squeezes", "Wrist Roller"
  ],

  neck_and_mobility_stretching: [
    "Arm Circles", "Calf Stretch", "Cat-Cow Stretch", "Chest Stretch",
    "Child's Pose", "Cobra Stretch", "Downward Dog", "Foam Rolling",
    "Hamstring Stretch", "Hip Circles", "Hip Flexor Stretch", "IT Band Stretch",
    "Leg Swings", "Neck Extension", "Neck Flexion", "Neck Lateral Flexion",
    "Neck Rotation", "Pigeon Pose", "Quad Stretch", "Seated Spinal Twist",
    "Shoulder Rolls", "Stretches (Calf)", "Stretches (Chest)", "Stretches (Hamstring)",
    "Stretches (Hip Flexor)", "Stretches (IT Band)", "Stretches (Quad)",
    "Thread the Needle", "Yoga Poses"
  ]
}.freeze


# 🆕 All available muscle groups for custom splits
CUSTOM_SPLIT_MUSCLES = WORKOUTS.keys.freeze

# 🆕 Recovery day options for custom splits (3-10 days)
RECOVERY_OPTIONS = (3..10).to_a.freeze



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

# 🆕 Simplified CLAUSE_LIBRARY with discrete ranges
CLAUSE_LIBRARY = {
  status: {
    options: ["Working set", "Warmup set", "Drop set", "Super set", "Heavy set", "Light set"],
    color: "blue",
    css_class: "badge-status"
  },
  reps: {
    options: (1..35).to_a,
    color: "green",
    css_class: "badge-reps"
  },
  weight: {
    options: (1..300).to_a,
    color: "yellow",
    css_class: "badge-weight"
  },
  reflection: {
    options: [
      "perfect form", "form broke down", "rushed the reps", "felt heavy", "too easy",
      "need more weight", "maxed out", "great pump", "good mind-muscle connection",
      "felt the stretch", "explosive power", "solid effort", "pushed to failure",
      "left some in tank", "personal best", "feeling fresh", "still recovering",
      "fired up", "mentally tired", "next time go heavier", "try different angle",
      "increase volume"
    ],
    color: "purple",
    css_class: "badge-reflection"
  }
}.freeze

# 🆕 Badge type definitions and utilities
BADGE_TYPES = {
  status: { icon: "🏃", description: "Set type (Working, Drop, etc.)" },
  reps: { icon: "🔢", description: "Repetition count" },
  weight: { icon: "⚖️", description: "Weight used" },
  reflection: { icon: "💭", description: "Notes and feelings" }
}.freeze

# 🆕 Helper methods for badge system
def self.badge_options_for(type)
  CLAUSE_LIBRARY.dig(type.to_sym, :options) || []
end

def self.badge_class_for(type)
  CLAUSE_LIBRARY.dig(type.to_sym, :css_class) || "badge-default"
end

def self.badge_color_for(type)
  CLAUSE_LIBRARY.dig(type.to_sym, :color) || "gray"
end

def self.all_badge_types
  BADGE_TYPES.keys
end

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
  custom_split: "Custom Split",
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
