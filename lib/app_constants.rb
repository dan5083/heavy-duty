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

  BENCHMARK_DATA = {
  chest: {
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
  },
  back: {
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
  },
  legs: {
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
  },
  shoulders: {
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
  },
  arms_biceps_and_triceps: {
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
  },
  core: {
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
  },
  entire_body: {
    "Burpees" => [
      "Started with ten burpees — full body was working hard.",
      "Second round, another ten — felt it everywhere by the end."
    ],
    "Kettlebell Swings" => [
      "Twenty swings with a 20 kilo bell, explosive hips.",
      "Second set, same weight — kept the power throughout."
    ],
    "Turkish Get-Ups" => [
      "Five per side with a 12 kilo bell, slow and controlled.",
      "Second round, same setup — really focused on stability."
    ],
    "Mountain Climbers" => [
      "Thirty seconds all-out, heart rate was flying.",
      "Second set, same time — legs were burning by the finish."
    ]
  },
  upper_body: {
    "Pull-Ups" => [
      "Eight clean pull-ups, full range of motion.",
      "Second set, managed six more — grip was starting to fail."
    ],
    "Push-Ups" => [
      "Twenty solid push-ups, chest to floor each time.",
      "Second round, dropped to fifteen — arms were fried."
    ],
    "Pike Push-Ups" => [
      "Twelve reps, really felt it in the shoulders.",
      "Second set, same count — maintained good form throughout."
    ],
    "Inverted Rows" => [
      "Fifteen reps on the bar, squeezed hard at the top.",
      "Second set, same rep count — back was pumped."
    ]
  },
  lower_body: {
    "Squats" => [
      "Fifteen bodyweight squats, ass to grass depth.",
      "Second set, another fifteen — quads were screaming."
    ],
    "Lunges" => [
      "Twenty alternating lunges, kept the balance tight.",
      "Second round, same count — glutes felt every step."
    ],
    "Single-Leg Deadlifts" => [
      "Ten per leg with bodyweight, wobbled a bit.",
      "Second set, same thing — balance was better this time."
    ],
    "Calf Raises" => [
      "Twenty-five slow reps, really squeezed at the top.",
      "Second set, same count — calves were on fire."
    ]
  },
  push_chest_shoulders_triceps: {
    "Bench Press" => [
      "Eight reps at 75 kilos, chest leading the movement.",
      "Second set, dropped to 70 kilos for ten clean reps."
    ],
    "Overhead Press" => [
      "Ten reps at 45 kilos, shoulders burning.",
      "Second round, same weight — triceps kicked in hard."
    ],
    "Tricep Pushdowns" => [
      "Fifteen reps at 30 kilos, kept elbows locked.",
      "Second set, same weight — really squeezed at the bottom."
    ],
    "Diamond Push-Ups" => [
      "Twelve diamond push-ups, triceps doing most of the work.",
      "Second round, managed ten — arms were shaking."
    ]
  },
  pull_back_biceps: {
    "Pull-Ups" => [
      "Nine pull-ups with a slow negative, back was working.",
      "Second set, hit seven more — biceps started cramping."
    ],
    "Barbell Rows" => [
      "Ten reps at 65 kilos, pulled to the sternum.",
      "Second round, same weight — squeezed hard at the top."
    ],
    "Barbell Curl" => [
      "Twelve reps at 25 kilos, strict form.",
      "Second set, dropped to 20 kilos for fifteen."
    ],
    "Face Pulls" => [
      "Fifteen reps at 20 kilos, really opened up the chest.",
      "Second round, same weight — rear delts were pumped."
    ]
  },
  chest_and_triceps: {
    "Incline Press" => [
      "Eight reps at 65 kilos, upper chest working hard.",
      "Second set, same weight — triceps took over near the end."
    ],
    "Cable Flys" => [
      "Twelve reps at 17.5 kilos, smooth and controlled.",
      "Second round, same weight — chest was fully pumped."
    ],
    "Close-Grip Bench Press" => [
      "Ten reps at 60 kilos, triceps leading the way.",
      "Second set, same weight — arms were shaking."
    ],
    "Overhead Tricep Extension" => [
      "Fifteen reps with a 20 kilo dumbbell, deep stretch.",
      "Second round, same weight — triceps were burning."
    ]
  },
  back_and_biceps: {
    "Lat Pulldown" => [
      "Twelve reps at 45 kilos, wide grip and full stretch.",
      "Second set, same weight — really squeezed the lats."
    ],
    "Seated Row" => [
      "Fifteen reps at 40 kilos, pulled to the lower chest.",
      "Second round, same setup — back was fully engaged."
    ],
    "Hammer Curls" => [
      "Ten reps with 15 kilo dumbbells, alternating arms.",
      "Second set, same weight — forearms joined the party."
    ],
    "Preacher Curls" => [
      "Twelve reps at 20 kilos, strict form on the EZ bar.",
      "Second round, dropped to 17.5 kilos for fifteen."
    ]
  },
  quads_and_calves: {
    "Leg Press" => [
      "Fifteen reps at 140 kilos, deep range of motion.",
      "Second set, same weight — quads were screaming."
    ],
    "Leg Extensions" => [
      "Twelve reps at 50 kilos, squeezed hard at the top.",
      "Second round, same weight — quad pump was intense."
    ],
    "Standing Calf Raises" => [
      "Twenty reps at 60 kilos, full stretch and contraction.",
      "Second set, same weight — calves were on fire."
    ],
    "Jump Squats" => [
      "Fifteen explosive jump squats, landed soft each time.",
      "Second round, another fifteen — legs felt like jello."
    ]
  },
  hamstrings_and_glutes: {
    "Romanian Deadlifts" => [
      "Ten reps at 70 kilos, really felt the hamstring stretch.",
      "Second set, same weight — glutes were firing hard."
    ],
    "Hip Thrusts" => [
      "Fifteen reps at 80 kilos, squeezed hard at the top.",
      "Second round, same weight — glutes were pumped."
    ],
    "Leg Curls" => [
      "Twelve reps at 40 kilos, slow and controlled.",
      "Second set, same weight — hamstrings were burning."
    ],
    "Glute Bridges" => [
      "Twenty bodyweight bridges, paused at the top.",
      "Second round, same count — felt it deep in the glutes."
    ]
  },
  biceps: {
    "Dumbbell Curl" => [
      "Twelve reps with 12 kilo dumbbells, alternating arms.",
      "Second set, same weight — biceps were fully pumped."
    ],
    "EZ-Bar Curl" => [
      "Ten reps at 25 kilos, strict form throughout.",
      "Second round, dropped to 22.5 kilos for twelve."
    ],
    "Concentration Curl" => [
      "Eight per arm with a 10 kilo dumbbell, really isolated.",
      "Second set, same weight — bicep was cramping."
    ],
    "21s" => [
      "One full set of 21s with 15 kilos — killer pump.",
      "Second round, same weight — arms felt like they'd explode."
    ]
  },
  triceps: {
    "Tricep Rope Pushdown" => [
      "Fifteen reps at 35 kilos, pulled apart at the bottom.",
      "Second set, same weight — triceps were screaming."
    ],
    "Overhead Dumbbell Extension" => [
      "Twelve reps with a 22.5 kilo dumbbell, deep stretch.",
      "Second round, same weight — felt it through the whole tricep."
    ],
    "Close-Grip Bench Press" => [
      "Ten reps at 55 kilos, elbows stayed tight.",
      "Second set, same weight — triceps took over completely."
    ],
    "Diamond Push-Ups" => [
      "Fifteen diamond push-ups, slow and controlled.",
      "Second round, managed twelve — arms were shaking."
    ]
  },
  quads: {
    "Front Squat" => [
      "Eight reps at 70 kilos, stayed upright throughout.",
      "Second set, same weight — quads were on fire."
    ],
    "Bulgarian Split Squat" => [
      "Ten per leg with 15 kilo dumbbells, deep range.",
      "Second round, same weight — front leg was burning."
    ],
    "Leg Extension" => [
      "Fifteen reps at 45 kilos, squeezed hard at the top.",
      "Second set, same weight — quad pump was insane."
    ],
    "Wall Sits" => [
      "Held for 45 seconds, thighs were shaking.",
      "Second round, same time — quads felt like they'd give out."
    ]
  },
  hamstrings: {
    "Romanian Deadlifts" => [
      "Twelve reps at 65 kilos, slow on the way down.",
      "Second set, same weight — hamstrings were stretching hard."
    ],
    "Leg Curl Machine" => [
      "Fifteen reps at 35 kilos, controlled the whole way.",
      "Second round, same weight — hamstrings were burning."
    ],
    "Good Mornings" => [
      "Ten reps at 40 kilos, felt the stretch through the back.",
      "Second set, same weight — hamstrings were tight."
    ],
    "Nordic Curls" => [
      "Five assisted Nordic curls, eccentric focus.",
      "Second round, managed four — hamstrings were screaming."
    ]
  },
  glutes_and_calves: {
    "Hip Thrusts" => [
      "Fifteen reps at 90 kilos, paused at the top.",
      "Second set, same weight — glutes were fully engaged."
    ],
    "Cable Kickbacks" => [
      "Twelve per leg at 15 kilos, squeezed hard.",
      "Second round, same weight — glutes were pumped."
    ],
    "Standing Calf Raise" => [
      "Twenty-five reps at 70 kilos, full range of motion.",
      "Second set, same weight — calves were cramping."
    ],
    "Donkey Calf Raise" => [
      "Twenty reps with bodyweight, deep stretch at the bottom.",
      "Second round, same count — calves felt like rocks."
    ]
  },
  chest_pectorals: {
    "Flat Bench Press" => [
      "Ten reps at 80 kilos, chest leading the movement.",
      "Second set, dropped to 75 kilos for twelve."
    ],
    "Pec Deck Machine" => [
      "Fifteen reps at 50 kilos, squeezed hard in the middle.",
      "Second round, same weight — chest was fully pumped."
    ],
    "Cable Crossover" => [
      "Twelve reps at 20 kilos each side, smooth motion.",
      "Second set, same weight — pecs were burning."
    ],
    "Incline Dumbbell Press" => [
      "Eight reps with 30 kilo dumbbells, upper chest focus.",
      "Second round, dropped to 27.5s for ten."
    ]
  },
  back_lats_trapezius_rhomboids: {
    "Deadlift" => [
      "Six reps at 100 kilos, full body engagement.",
      "Second set, same weight — back was working overtime."
    ],
    "Lat Pulldown" => [
      "Twelve reps at 50 kilos, wide grip and full stretch.",
      "Second round, same weight — lats were pumped."
    ],
    "Face Pulls" => [
      "Twenty reps at 25 kilos, really opened up the chest.",
      "Second set, same weight — rear delts and rhomboids were burning."
    ],
    "T-Bar Row" => [
      "Ten reps at 45 kilos, pulled to the sternum.",
      "Second round, same weight — whole back was engaged."
    ]
  },
  shoulders_deltoids: {
    "Overhead Press" => [
      "Eight reps at 50 kilos, strict form overhead.",
      "Second set, dropped to 45 kilos for ten."
    ],
    "Lateral Raises" => [
      "Fifteen reps with 10 kilo dumbbells, controlled tempo.",
      "Second round, same weight — shoulders were on fire."
    ],
    "Reverse Fly" => [
      "Twelve reps with 8 kilo dumbbells, squeezed the rear delts.",
      "Second set, same weight — posterior delts were pumped."
    ],
    "Arnold Press" => [
      "Ten reps with 17.5 kilo dumbbells, full rotation.",
      "Second round, same weight — all three heads were working."
    ]
  },
  legs_quads_and_hamstrings: {
    "Barbell Squat" => [
      "Ten reps at 90 kilos, deep and controlled.",
      "Second set, same weight — legs were shaking on the way up."
    ],
    "Romanian Deadlift" => [
      "Twelve reps at 75 kilos, hamstrings got a deep stretch.",
      "Second round, same weight — felt it through the whole posterior chain."
    ],
    "Walking Lunges" => [
      "Twenty steps with 20 kilo dumbbells, alternating legs.",
      "Second set, same weight — quads and glutes were burning."
    ],
    "Leg Curls" => [
      "Fifteen reps at 45 kilos, slow and controlled.",
      "Second round, same weight — hamstrings were cramping."
    ]
  },
  legs_glutes_and_calves: {
    "Hip Thrusts" => [
      "Twelve reps at 100 kilos, squeezed hard at the top.",
      "Second set, same weight — glutes were fully activated."
    ],
    "Donkey Calf Raise" => [
      "Twenty-five reps with bodyweight, full range.",
      "Second round, same count — calves were burning."
    ],
    "Cable Kickbacks" => [
      "Fifteen per leg at 20 kilos, really isolated the glutes.",
      "Second set, same weight — glutes were pumped."
    ],
    "Step-Ups" => [
      "Ten per leg with 25 kilo dumbbells, controlled tempo.",
      "Second round, same weight — glutes and calves were working hard."
    ]
  },
  core_abs_and_obliques: {
    "Bicycle Crunches" => [
      "Thirty total reps, alternating sides smoothly.",
      "Second set, same count — obliques were burning."
    ],
    "Plank" => [
      "Held for 75 seconds, stayed tight throughout.",
      "Second round, managed 60 seconds — core was shaking."
    ],
    "Side Plank" => [
      "Thirty seconds per side, really felt the obliques.",
      "Second set, same time each side — abs were on fire."
    ],
    "Hanging Leg Raises" => [
      "Twelve strict leg raises, no swinging.",
      "Second round, managed ten — lower abs were screaming."
    ]
  },
  forearms_and_grip_strength: {
    "Farmer's Walk" => [
      "Forty meters with 30 kilo dumbbells, grip was slipping.",
      "Second round, same distance — forearms were burning."
    ],
    "Wrist Curls" => [
      "Twenty reps with a 10 kilo dumbbell, full range.",
      "Second set, same weight — forearms were pumped."
    ],
    "Dead Hangs" => [
      "Held for 30 seconds, grip was failing near the end.",
      "Second round, managed 25 seconds — hands were cramping."
    ],
    "Reverse Curls" => [
      "Fifteen reps with a 15 kilo barbell, felt it in the forearms.",
      "Second set, same weight — grip strength was fading."
    ]
  },
  neck_and_mobility_stretching: {
    "Neck Flexion" => [
      "Held gentle neck flexion for 30 seconds, felt the stretch.",
      "Second round, same time — neck felt more relaxed."
    ],
    "Foam Rolling" => [
      "Two minutes on the IT band, worked out some knots.",
      "Second session, focused on the calves — much looser now."
    ],
    "Cat-Cow Stretch" => [
      "Ten slow movements, really opened up the spine.",
      "Second set, same count — back felt much more mobile."
    ],
    "Hip Circles" => [
      "Ten circles each direction, loosened up the hips.",
      "Second round, same pattern — much better range of motion."
    ]
  }
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
