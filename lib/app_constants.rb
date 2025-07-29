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


# Flattened EXERCISE_TAGS hash with generous muscle group inclusion
EXERCISE_TAGS = {
  # A Exercises
  "Ab Crunch Machine" => [:core, :core_abs_and_obliques],

  "Ab Wheel Rollouts" => [:core, :core_abs_and_obliques, :shoulders, :shoulders_deltoids, :chest, :chest_pectorals, :triceps, :upper_body, :entire_body],

  "Arnold Press" => [:shoulders, :shoulders_deltoids, :upper_body, :push_chest_shoulders_triceps, :triceps, :arms_biceps_and_triceps, :chest, :chest_pectorals, :core, :entire_body],

  "Arm Circles" => [:shoulders, :shoulders_deltoids, :neck_and_mobility_stretching, :upper_body],

  "Assault Bike" => [:entire_body, :cardio, :legs, :upper_body, :lower_body, :shoulders, :core, :quads, :hamstrings, :glutes_and_calves],

  "Assisted Pull-Up Machine" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :upper_body, :biceps, :arms_biceps_and_triceps, :shoulders, :shoulders_deltoids, :core, :forearms_and_grip_strength],

  # B Exercises
  "Band Pull-Aparts" => [:shoulders, :shoulders_deltoids, :back, :back_lats_trapezius_rhomboids, :upper_body, :pull_back_biceps, :chest, :chest_pectorals],

  "Barbell Rows" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :upper_body, :biceps, :arms_biceps_and_triceps, :shoulders, :shoulders_deltoids, :core, :forearms_and_grip_strength, :legs, :lower_body, :entire_body],

  "Barbell Holds" => [:forearms_and_grip_strength, :back, :back_lats_trapezius_rhomboids, :upper_body, :shoulders, :core, :biceps, :triceps, :entire_body],

  "Battle Ropes" => [:entire_body, :cardio, :shoulders, :shoulders_deltoids, :core, :core_abs_and_obliques, :upper_body, :back, :back_lats_trapezius_rhomboids, :chest, :legs, :forearms_and_grip_strength],

  "Bear Crawls" => [:entire_body, :core, :core_abs_and_obliques, :shoulders, :shoulders_deltoids, :cardio, :upper_body, :chest, :triceps, :legs, :lower_body, :quads],

  "Bench Press" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :upper_body, :triceps, :arms_biceps_and_triceps, :shoulders, :shoulders_deltoids, :core, :entire_body],

  "Bench Press (Barbell)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :upper_body, :triceps, :arms_biceps_and_triceps, :shoulders, :shoulders_deltoids, :core, :entire_body],

  "Bench Press (Close-Grip)" => [:triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :chest_and_triceps, :chest, :chest_pectorals, :upper_body, :shoulders, :shoulders_deltoids, :core],

  "Bench Press (Decline)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :upper_body, :triceps, :arms_biceps_and_triceps, :shoulders, :core],

  "Bench Press (Dumbbell)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :upper_body, :triceps, :arms_biceps_and_triceps, :shoulders, :shoulders_deltoids, :core, :entire_body],

  "Bench Press (Incline)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :upper_body, :shoulders, :shoulders_deltoids, :triceps, :arms_biceps_and_triceps, :core],

  "Bench Press (Iso-lateral)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :upper_body, :shoulders, :shoulders_deltoids, :triceps, :arms_biceps_and_triceps, :core],

  "Bench Press (Regular)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :upper_body, :triceps, :arms_biceps_and_triceps, :shoulders, :shoulders_deltoids, :core, :entire_body],

  "Bench Press (Smith Machine)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :upper_body, :triceps, :arms_biceps_and_triceps, :shoulders, :shoulders_deltoids, :core],

  "Bent-Over Rows" => [:back, :back_lats_trapezius_rhomboids, :back_and_biceps, :pull_back_biceps, :upper_body, :biceps, :arms_biceps_and_triceps, :shoulders, :shoulders_deltoids, :core, :legs, :lower_body, :hamstrings, :glutes_and_calves, :forearms_and_grip_strength, :entire_body],

  "Bicycle Crunches" => [:core, :core_abs_and_obliques],

  "Bicep Curl Machine" => [:biceps, :arms_biceps_and_triceps, :pull_back_biceps, :upper_body, :forearms_and_grip_strength, :back_and_biceps],

  "Bike (Air)" => [:cardio, :legs, :lower_body, :entire_body, :quads, :hamstrings, :glutes_and_calves, :quads_and_calves, :core],

  "Bike (Assault)" => [:cardio, :entire_body, :legs, :upper_body, :lower_body, :shoulders, :core, :quads, :hamstrings, :glutes_and_calves],

  "Bike (Outdoor)" => [:cardio, :legs, :lower_body, :quads, :hamstrings, :glutes_and_calves, :quads_and_calves, :core, :entire_body],

  "Bike (Recumbent)" => [:cardio, :legs, :lower_body, :quads, :quads_and_calves, :hamstrings, :glutes_and_calves, :core],

  "Bike (Road)" => [:cardio, :legs, :lower_body, :quads, :hamstrings, :glutes_and_calves, :quads_and_calves, :core, :entire_body],

  "Bike (Spin)" => [:cardio, :legs, :lower_body, :quads, :hamstrings, :glutes_and_calves, :quads_and_calves, :core, :entire_body],

  "Bike (Stationary)" => [:cardio, :legs, :lower_body, :quads, :quads_and_calves, :hamstrings, :glutes_and_calves, :core],

  "Bird Dog" => [:core, :core_abs_and_obliques, :back, :back_lats_trapezius_rhomboids, :shoulders, :shoulders_deltoids, :hamstrings_and_glutes, :neck_and_mobility_stretching],

  "Board Press" => [:triceps, :arms_biceps_and_triceps, :chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :upper_body, :shoulders],

  "Box Jumps" => [:entire_body, :legs, :lower_body, :quads_and_calves, :quads, :cardio, :hamstrings_and_glutes, :glutes_and_calves, :core, :legs_quads_and_hamstrings, :legs_glutes_and_calves],

  "Box Jump Burpees" => [:entire_body, :cardio, :legs, :upper_body, :core, :lower_body, :chest, :shoulders, :triceps, :quads, :hamstrings_and_glutes],

  "Boxing" => [:cardio, :entire_body, :upper_body, :core, :core_abs_and_obliques, :shoulders, :shoulders_deltoids, :chest, :triceps, :legs, :lower_body],

  "Bradford Press" => [:shoulders, :shoulders_deltoids, :push_chest_shoulders_triceps, :upper_body, :triceps, :arms_biceps_and_triceps, :core, :chest],

  "Broad Jumps" => [:lower_body, :legs, :quads_and_calves, :quads, :cardio, :hamstrings_and_glutes, :glutes_and_calves, :core, :entire_body, :legs_quads_and_hamstrings, :legs_glutes_and_calves],

  "Bulgarian Split Squats" => [:lower_body, :legs, :quads_and_calves, :hamstrings_and_glutes, :legs_quads_and_hamstrings, :legs_glutes_and_calves, :quads, :hamstrings, :glutes_and_calves, :core, :entire_body],

  "Burpees" => [:entire_body, :cardio, :core, :core_abs_and_obliques, :upper_body, :legs, :lower_body, :chest, :shoulders, :triceps, :quads, :hamstrings_and_glutes],

  # C Exercises
  "Cable Chest Fly" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :upper_body, :shoulders, :shoulders_deltoids, :triceps],

  "Cable Crossover" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :upper_body, :shoulders, :shoulders_deltoids, :triceps, :core],

  "Cable Crunches" => [:core, :core_abs_and_obliques, :shoulders, :triceps, :upper_body],

  "Cable Curls" => [:biceps, :arms_biceps_and_triceps, :pull_back_biceps, :upper_body, :forearms_and_grip_strength, :back_and_biceps],

  "Cable Flyes" => [:chest, :chest_pectorals, :chest_and_triceps, :push_chest_shoulders_triceps, :upper_body, :shoulders, :shoulders_deltoids, :triceps],

  "Cable Kickbacks" => [:hamstrings_and_glutes, :legs_glutes_and_calves, :legs, :lower_body, :hamstrings, :glutes_and_calves, :core],

  "Cable Lateral Raises" => [:shoulders, :shoulders_deltoids, :push_chest_shoulders_triceps, :upper_body, :triceps, :core],

  "Cable Overhead Extension" => [:triceps, :arms_biceps_and_triceps, :chest_and_triceps, :push_chest_shoulders_triceps, :upper_body, :shoulders, :core],

  "Cable Overhead Tricep Extension" => [:triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :chest_and_triceps, :upper_body, :shoulders, :core],

  "Cable Pull-Throughs" => [:hamstrings_and_glutes, :hamstrings, :legs, :lower_body, :glutes_and_calves, :legs_quads_and_hamstrings, :legs_glutes_and_calves, :core, :back],

  "Cable Rear Delt Flyes" => [:shoulders, :shoulders_deltoids, :back, :back_lats_trapezius_rhomboids, :upper_body, :pull_back_biceps, :triceps],

  "Cable Rows" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :upper_body, :biceps, :arms_biceps_and_triceps, :shoulders, :shoulders_deltoids, :core, :forearms_and_grip_strength],

  "Cable Wrist Curls" => [:forearms_and_grip_strength, :arms_biceps_and_triceps, :biceps],

  "Calf Press (Leg Press)" => [:glutes_and_calves, :quads_and_calves, :legs_glutes_and_calves, :legs, :lower_body, :quads, :hamstrings],

  "Calf Press (Leg Press Machine)" => [:quads_and_calves, :glutes_and_calves, :legs_glutes_and_calves, :legs, :lower_body, :quads, :hamstrings],

  "Calf Raises (Donkey)" => [:lower_body, :legs, :quads_and_calves, :glutes_and_calves, :legs_glutes_and_calves, :hamstrings_and_glutes, :core],

  "Calf Raises (Machine)" => [:quads_and_calves, :glutes_and_calves, :legs_glutes_and_calves, :legs, :lower_body],

  "Calf Raises (Seated)" => [:lower_body, :legs, :quads_and_calves, :glutes_and_calves, :legs_glutes_and_calves],

  "Calf Raises (Single-Leg)" => [:lower_body, :legs, :quads_and_calves, :glutes_and_calves, :legs_glutes_and_calves, :core, :hamstrings_and_glutes],

  "Calf Raises (Standing)" => [:lower_body, :legs, :quads_and_calves, :glutes_and_calves, :legs_glutes_and_calves, :core],

  "Calf Raises (Wall)" => [:quads_and_calves, :glutes_and_calves, :legs_glutes_and_calves, :legs, :lower_body],

  "Calf Stretch" => [:neck_and_mobility_stretching, :legs, :lower_body, :glutes_and_calves, :quads_and_calves],

  "California Press" => [:triceps, :arms_biceps_and_triceps, :chest_and_triceps, :chest, :chest_pectorals, :push_chest_shoulders_triceps, :upper_body, :shoulders],

  "Captain's Chair" => [:core, :core_abs_and_obliques, :shoulders, :triceps, :forearms_and_grip_strength, :upper_body],

  "Cat-Cow Stretch" => [:neck_and_mobility_stretching, :back, :back_lats_trapezius_rhomboids, :core, :core_abs_and_obliques, :shoulders],

  "Chest Dips" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :triceps, :arms_biceps_and_triceps, :upper_body, :shoulders, :shoulders_deltoids, :core],

  "Chest Fly Machine" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :upper_body, :shoulders, :shoulders_deltoids],

  "Chest Press Machine" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :triceps, :arms_biceps_and_triceps, :upper_body, :shoulders],

  "Chest Press Machine (Decline)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :triceps, :arms_biceps_and_triceps, :upper_body, :shoulders],

  "Chest Press Machine (Hammer Strength)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :triceps, :arms_biceps_and_triceps, :upper_body, :shoulders, :core],

  "Chest Press Machine (Incline)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :shoulders_deltoids, :triceps, :arms_biceps_and_triceps, :upper_body],

  "Chest Stretch" => [:neck_and_mobility_stretching, :chest, :chest_pectorals, :shoulders, :shoulders_deltoids, :upper_body],

  "Chest-Supported Rows" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :upper_body, :biceps, :arms_biceps_and_triceps, :shoulders, :shoulders_deltoids, :forearms_and_grip_strength],

  "Child's Pose" => [:neck_and_mobility_stretching, :back, :back_lats_trapezius_rhomboids, :shoulders, :shoulders_deltoids, :core, :legs, :glutes_and_calves],

  "Chin-Ups" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :upper_body, :biceps, :arms_biceps_and_triceps, :shoulders, :shoulders_deltoids, :core, :forearms_and_grip_strength, :entire_body],

  "Circuit Training" => [:cardio, :entire_body, :upper_body, :lower_body, :core, :legs, :shoulders, :chest, :back],

  "Clamshells" => [:hamstrings_and_glutes, :legs_glutes_and_calves, :legs, :lower_body, :glutes_and_calves, :core],

  "Clean and Press" => [:entire_body, :shoulders, :shoulders_deltoids, :legs, :lower_body, :upper_body, :core, :back, :triceps, :quads, :hamstrings_and_glutes, :cardio],

  "Cobra Stretch" => [:neck_and_mobility_stretching, :back, :back_lats_trapezius_rhomboids, :chest, :chest_pectorals, :core, :core_abs_and_obliques, :shoulders],

  "Commando Pull-Ups" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :upper_body, :biceps, :arms_biceps_and_triceps, :core, :core_abs_and_obliques, :shoulders, :forearms_and_grip_strength, :entire_body],

  "Cross-Body Hammer Curls" => [:biceps, :arms_biceps_and_triceps, :forearms_and_grip_strength, :pull_back_biceps, :upper_body, :core],

  "Crunches (Bicycle)" => [:core, :core_abs_and_obliques],

  "Crunches (Cable)" => [:core, :core_abs_and_obliques, :shoulders, :triceps, :upper_body],

  "Crunches (Machine)" => [:core, :core_abs_and_obliques],

  "Crunches (Oblique)" => [:core, :core_abs_and_obliques],

  "Crunches (Regular)" => [:core, :core_abs_and_obliques],

  "Crunches (Reverse)" => [:core, :core_abs_and_obliques, :shoulders],

  "Cuban Press" => [:shoulders, :shoulders_deltoids, :upper_body, :triceps, :arms_biceps_and_triceps, :back, :back_lats_trapezius_rhomboids, :core],

  "Curls (21s)" => [:biceps, :arms_biceps_and_triceps, :back_and_biceps, :pull_back_biceps, :upper_body, :forearms_and_grip_strength],

  "Curls (21s Bicep)" => [:biceps, :arms_biceps_and_triceps, :pull_back_biceps, :back_and_biceps, :upper_body, :forearms_and_grip_strength],

  "Curls (Barbell)" => [:biceps, :arms_biceps_and_triceps, :pull_back_biceps, :back_and_biceps, :upper_body, :forearms_and_grip_strength, :core],

  "Curls (Cable)" => [:biceps, :arms_biceps_and_triceps, :pull_back_biceps, :back_and_biceps, :upper_body, :forearms_and_grip_strength],

  "Curls (Cable Hammer)" => [:biceps, :arms_biceps_and_triceps, :pull_back_biceps, :forearms_and_grip_strength, :upper_body],

  "Curls (Concentration)" => [:biceps, :arms_biceps_and_triceps, :pull_back_biceps, :back_and_biceps, :upper_body, :forearms_and_grip_strength, :core],

  "Curls (Cross-Body)" => [:biceps, :arms_biceps_and_triceps, :forearms_and_grip_strength, :pull_back_biceps, :core],

  "Curls (Drag)" => [:biceps, :arms_biceps_and_triceps, :pull_back_biceps, :forearms_and_grip_strength, :shoulders],

  "Curls (Dumbbell)" => [:biceps, :arms_biceps_and_triceps, :pull_back_biceps, :upper_body, :forearms_and_grip_strength, :core],

  "Curls (EZ-Bar)" => [:biceps, :arms_biceps_and_triceps, :back_and_biceps, :pull_back_biceps, :forearms_and_grip_strength, :upper_body],

  "Curls (Hammer)" => [:biceps, :arms_biceps_and_triceps, :pull_back_biceps, :upper_body, :forearms_and_grip_strength],

  "Curls (Incline Dumbbell)" => [:biceps, :arms_biceps_and_triceps, :pull_back_biceps, :upper_body, :forearms_and_grip_strength, :shoulders, :chest],

  "Curls (Machine)" => [:biceps, :arms_biceps_and_triceps, :pull_back_biceps, :upper_body, :forearms_and_grip_strength],

  "Curls (Preacher)" => [:biceps, :arms_biceps_and_triceps, :pull_back_biceps, :back_and_biceps, :upper_body, :forearms_and_grip_strength, :core],

  "Curls (Reverse)" => [:biceps, :arms_biceps_and_triceps, :pull_back_biceps, :forearms_and_grip_strength, :upper_body],

  "Curls (Seated Dumbbell)" => [:biceps, :arms_biceps_and_triceps, :pull_back_biceps, :upper_body, :forearms_and_grip_strength, :core],

  "Curls (Spider)" => [:biceps, :arms_biceps_and_triceps, :pull_back_biceps, :forearms_and_grip_strength, :core],

  "Curls (Wide-Grip)" => [:biceps, :arms_biceps_and_triceps, :pull_back_biceps, :forearms_and_grip_strength, :shoulders],

  "Curls (Wrist)" => [:forearms_and_grip_strength, :arms_biceps_and_triceps, :biceps],

  "Curls (Zottman)" => [:biceps, :arms_biceps_and_triceps, :forearms_and_grip_strength, :pull_back_biceps],

  "Curtsy Lunges" => [:hamstrings_and_glutes, :legs_glutes_and_calves, :legs, :lower_body, :quads, :quads_and_calves, :glutes_and_calves, :core, :legs_quads_and_hamstrings],

  "Cycling (Mountain)" => [:cardio, :legs, :lower_body, :quads, :hamstrings, :glutes_and_calves, :quads_and_calves, :core, :entire_body, :shoulders],

  "Cycling (Outdoor)" => [:cardio, :legs, :lower_body, :quads, :hamstrings, :glutes_and_calves, :quads_and_calves, :core, :entire_body],

  "Cycling (Road)" => [:cardio, :legs, :lower_body, :quads, :hamstrings, :glutes_and_calves, :quads_and_calves, :core, :entire_body],

  "Cyclist Squats" => [:quads, :quads_and_calves, :legs_quads_and_hamstrings, :legs, :lower_body, :hamstrings_and_glutes, :glutes_and_calves, :core],

  # D Exercises
  "Dance Cardio" => [:cardio, :entire_body, :legs, :lower_body, :core, :core_abs_and_obliques, :shoulders, :upper_body, :quads, :hamstrings_and_glutes],

  "Dead Bug" => [:core, :core_abs_and_obliques, :shoulders, :shoulders_deltoids, :back, :back_lats_trapezius_rhomboids, :upper_body, :legs],

  "Dead Hangs" => [:forearms_and_grip_strength, :back, :back_lats_trapezius_rhomboids, :shoulders, :shoulders_deltoids, :upper_body, :biceps, :pull_back_biceps, :core],

  "Deadlifts" => [:entire_body, :back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :hamstrings, :hamstrings_and_glutes, :legs, :lower_body, :glutes_and_calves, :legs_quads_and_hamstrings, :legs_glutes_and_calves, :core, :forearms_and_grip_strength, :shoulders, :quads, :upper_body],

  "Deadlifts (Romanian)" => [:hamstrings, :hamstrings_and_glutes, :legs, :lower_body, :legs_quads_and_hamstrings, :glutes_and_calves, :legs_glutes_and_calves, :back, :back_lats_trapezius_rhomboids, :core, :forearms_and_grip_strength, :quads, :entire_body],

  "Deadlifts (Single-Leg)" => [:hamstrings, :hamstrings_and_glutes, :legs, :lower_body, :legs_quads_and_hamstrings, :glutes_and_calves, :legs_glutes_and_calves, :core, :back, :quads, :entire_body],

  "Deadlifts (Stiff-Leg)" => [:hamstrings, :hamstrings_and_glutes, :legs, :lower_body, :legs_quads_and_hamstrings, :glutes_and_calves, :legs_glutes_and_calves, :back, :back_lats_trapezius_rhomboids, :core, :entire_body],

  "Deadlifts (Sumo)" => [:hamstrings_and_glutes, :legs, :lower_body, :legs_quads_and_hamstrings, :legs_glutes_and_calves, :back, :back_lats_trapezius_rhomboids, :quads, :quads_and_calves, :glutes_and_calves, :core, :forearms_and_grip_strength, :entire_body],

  "Decline Sit-Ups" => [:core, :core_abs_and_obliques, :legs, :quads],

  "Devil's Press" => [:entire_body, :shoulders, :shoulders_deltoids, :chest, :chest_pectorals, :legs, :lower_body, :core, :core_abs_and_obliques, :triceps, :back, :cardio, :quads, :hamstrings_and_glutes],

  "Diamond Push-Ups" => [:triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :chest, :chest_pectorals, :upper_body, :shoulders, :shoulders_deltoids, :core],

  "Dips" => [:chest, :chest_pectorals, :triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :upper_body, :shoulders, :shoulders_deltoids, :core],

  "Dips (Tricep)" => [:triceps, :arms_biceps_and_triceps, :chest_and_triceps, :push_chest_shoulders_triceps, :chest, :chest_pectorals, :shoulders, :upper_body, :core],

  "Donkey Kicks" => [:hamstrings_and_glutes, :legs_glutes_and_calves, :glutes_and_calves, :core, :core_abs_and_obliques, :legs, :hamstrings],

  "Downward Dog" => [:neck_and_mobility_stretching, :shoulders, :shoulders_deltoids, :back, :back_lats_trapezius_rhomboids, :hamstrings, :hamstrings_and_glutes, :legs, :core, :upper_body, :triceps],

  "Dragon Flags" => [:core, :core_abs_and_obliques, :shoulders, :shoulders_deltoids, :triceps, :back, :upper_body, :entire_body],

  "Dumbbell Flyes" => [:chest, :chest_pectorals, :chest_and_triceps, :push_chest_shoulders_triceps, :upper_body, :shoulders, :shoulders_deltoids, :triceps],

  "Dumbbell Flyes (Decline)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :upper_body, :shoulders, :triceps],

  "Dumbbell Flyes (Incline)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :shoulders_deltoids, :upper_body, :triceps],

  "Dumbbell Holds" => [:forearms_and_grip_strength, :shoulders, :shoulders_deltoids, :upper_body, :core, :back, :triceps, :entire_body],

  "Dumbbell Shoulder Press" => [:shoulders, :shoulders_deltoids, :push_chest_shoulders_triceps, :triceps, :arms_biceps_and_triceps, :upper_body, :core, :chest],

  # E Exercises
  "Elliptical" => [:cardio, :legs, :lower_body, :entire_body, :quads, :hamstrings, :glutes_and_calves, :quads_and_calves, :core, :upper_body],

  "Extensions (Cable Overhead)" => [:triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :upper_body, :core],

  "Extensions (Dumbbell Overhead)" => [:triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :upper_body, :core],

  "Extensions (Lying Tricep)" => [:triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :upper_body, :core],

  "Extensions (Machine Tricep)" => [:triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :upper_body],

  "Extensions (Overhead Tricep)" => [:triceps, :arms_biceps_and_triceps, :chest_and_triceps, :push_chest_shoulders_triceps, :shoulders, :upper_body, :core],

  "Extensions (Seated Tricep)" => [:triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :upper_body, :core],

  "Extensions (Single-Arm Tricep)" => [:triceps, :arms_biceps_and_triceps, :chest_and_triceps, :push_chest_shoulders_triceps, :shoulders, :upper_body, :core],

  # F Exercises
  "Face Pulls" => [:shoulders, :shoulders_deltoids, :back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :upper_body, :biceps, :triceps, :core],

  "Farmer's Walk" => [:forearms_and_grip_strength, :entire_body, :core, :core_abs_and_obliques, :legs, :lower_body, :shoulders, :shoulders_deltoids, :back, :upper_body, :quads, :hamstrings_and_glutes, :glutes_and_calves],

  "Farmer's Walk on Toes" => [:glutes_and_calves, :legs_glutes_and_calves, :forearms_and_grip_strength, :core, :core_abs_and_obliques, :quads_and_calves, :legs, :lower_body, :shoulders, :entire_body],

  "Farmer's Walks" => [:entire_body, :forearms_and_grip_strength, :core, :core_abs_and_obliques, :legs, :lower_body, :shoulders, :shoulders_deltoids, :back, :upper_body, :quads, :hamstrings_and_glutes, :glutes_and_calves],

  "Fat Bar Holds" => [:forearms_and_grip_strength, :back, :back_lats_trapezius_rhomboids, :shoulders, :shoulders_deltoids, :upper_body, :biceps, :core],

  "Finger Extensions" => [:forearms_and_grip_strength, :arms_biceps_and_triceps],

  "Finger Walks" => [:forearms_and_grip_strength, :arms_biceps_and_triceps],

  "Fire Hydrants" => [:hamstrings_and_glutes, :legs_glutes_and_calves, :glutes_and_calves, :core, :core_abs_and_obliques, :legs, :hamstrings],

  "Flutter Kicks" => [:core, :core_abs_and_obliques, :legs, :lower_body, :quads, :hamstrings],

  "Flyes (Cable)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :shoulders_deltoids, :upper_body, :triceps],

  "Flyes (Cable High to Low)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :triceps, :upper_body],

  "Flyes (Cable Low to High)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :shoulders_deltoids, :upper_body, :triceps],

  "Flyes (Decline Dumbbell)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :triceps, :upper_body],

  "Flyes (Dumbbell)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :shoulders_deltoids, :upper_body, :triceps],

  "Flyes (Dumbbell Decline)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :triceps, :upper_body],

  "Flyes (Dumbbell Incline)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :shoulders_deltoids, :upper_body, :triceps],

  "Flyes (Incline Dumbbell)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :shoulders_deltoids, :upper_body, :triceps],

  "Foam Rolling" => [:neck_and_mobility_stretching, :entire_body, :legs, :back, :shoulders, :core],

  "French Press" => [:triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :upper_body, :core],

  "Frog Pumps" => [:hamstrings_and_glutes, :legs_glutes_and_calves, :glutes_and_calves, :core, :core_abs_and_obliques, :legs, :hamstrings],

  "Front Raises" => [:shoulders, :shoulders_deltoids, :push_chest_shoulders_triceps, :upper_body, :chest, :core, :triceps],

  "Front Squats" => [:quads, :quads_and_calves, :legs, :lower_body, :legs_quads_and_hamstrings, :core, :core_abs_and_obliques, :shoulders, :shoulders_deltoids, :upper_body, :hamstrings_and_glutes, :glutes_and_calves, :entire_body],

  # G Exercises
  "Glute Bridges" => [:hamstrings_and_glutes, :legs_glutes_and_calves, :legs, :lower_body, :core, :core_abs_and_obliques, :glutes_and_calves, :hamstrings, :quads],

  "Glute Bridges (Single-Leg)" => [:hamstrings_and_glutes, :legs_glutes_and_calves, :legs, :lower_body, :core, :core_abs_and_obliques, :glutes_and_calves, :hamstrings, :quads],

  "Glute Ham Raises" => [:hamstrings, :hamstrings_and_glutes, :legs, :lower_body, :legs_quads_and_hamstrings, :glutes_and_calves, :legs_glutes_and_calves, :core, :back],

  "Glute Ham Raise Machine" => [:hamstrings, :hamstrings_and_glutes, :legs, :lower_body, :legs_quads_and_hamstrings, :glutes_and_calves, :legs_glutes_and_calves, :core],

  "Goblet Squats" => [:quads, :quads_and_calves, :legs, :lower_body, :legs_quads_and_hamstrings, :forearms_and_grip_strength, :core, :shoulders, :upper_body, :hamstrings_and_glutes, :glutes_and_calves, :entire_body],

  "Good Mornings" => [:hamstrings, :hamstrings_and_glutes, :back, :back_lats_trapezius_rhomboids, :legs_quads_and_hamstrings, :lower_body, :legs, :glutes_and_calves, :legs_glutes_and_calves, :core, :entire_body],

  "Grip Crushers" => [:forearms_and_grip_strength, :arms_biceps_and_triceps],

  # H Exercises
  "Hack Squats" => [:quads, :quads_and_calves, :legs, :lower_body, :legs_quads_and_hamstrings, :hamstrings_and_glutes, :glutes_and_calves, :legs_glutes_and_calves, :core],

  "Hammer Curls" => [:biceps, :arms_biceps_and_triceps, :forearms_and_grip_strength, :pull_back_biceps, :upper_body],

  "Hamstring Stretch" => [:neck_and_mobility_stretching, :hamstrings, :hamstrings_and_glutes, :legs, :lower_body, :legs_quads_and_hamstrings, :glutes_and_calves],

  "Handstand Push-Ups" => [:shoulders, :shoulders_deltoids, :push_chest_shoulders_triceps, :triceps, :arms_biceps_and_triceps, :upper_body, :core, :core_abs_and_obliques, :chest, :entire_body],

  "Hanging Leg Raises" => [:core, :core_abs_and_obliques, :forearms_and_grip_strength, :shoulders, :back, :upper_body, :legs],

  "Hercules Hold" => [:shoulders, :shoulders_deltoids, :forearms_and_grip_strength, :core, :core_abs_and_obliques, :upper_body, :back, :triceps, :entire_body],

  "Hex Press" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :triceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :core],

  "HIIT Circuit" => [:cardio, :entire_body, :core, :core_abs_and_obliques, :legs, :upper_body, :shoulders, :chest, :back],

  "High Knees" => [:cardio, :legs, :lower_body, :core, :core_abs_and_obliques, :quads, :quads_and_calves, :hamstrings_and_glutes, :entire_body],

  "High Pulls" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :shoulders, :shoulders_deltoids, :upper_body, :biceps, :legs, :core, :entire_body, :forearms_and_grip_strength],

  "Hiking" => [:cardio, :legs, :lower_body, :glutes_and_calves, :legs_glutes_and_calves, :quads, :hamstrings_and_glutes, :core, :entire_body, :quads_and_calves],

  "Hip Circles" => [:neck_and_mobility_stretching, :legs, :lower_body, :core, :core_abs_and_obliques, :hamstrings_and_glutes, :glutes_and_calves],

  "Hip Flexor Stretch" => [:neck_and_mobility_stretching, :legs, :lower_body, :quads, :hamstrings_and_glutes, :core],

  "Hip Thrusts" => [:hamstrings_and_glutes, :legs_glutes_and_calves, :legs, :lower_body, :core, :core_abs_and_obliques, :glutes_and_calves, :hamstrings, :quads, :entire_body],

  "Hip Thrusts (Machine)" => [:hamstrings_and_glutes, :legs_glutes_and_calves, :legs, :lower_body, :glutes_and_calves, :hamstrings, :core, :quads],

  "Hip Thrusts (Single-Leg)" => [:hamstrings_and_glutes, :legs_glutes_and_calves, :legs, :lower_body, :core, :core_abs_and_obliques, :glutes_and_calves, :hamstrings, :quads],

  "Hollow Body Hold" => [:core, :core_abs_and_obliques, :shoulders, :shoulders_deltoids, :triceps, :upper_body, :back],

  "Hyperextensions" => [:back, :back_lats_trapezius_rhomboids, :hamstrings, :hamstrings_and_glutes, :core, :glutes_and_calves, :legs, :lower_body],

  # I Exercises
  "Incline Dumbbell Press" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :shoulders_deltoids, :triceps, :arms_biceps_and_triceps, :upper_body, :core],

  "Inverted Rows" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :upper_body, :shoulders, :shoulders_deltoids, :core, :forearms_and_grip_strength],

  "Isometric Holds" => [:biceps, :arms_biceps_and_triceps, :forearms_and_grip_strength, :pull_back_biceps, :upper_body, :shoulders, :core],

  "IT Band Stretch" => [:neck_and_mobility_stretching, :legs, :lower_body, :hamstrings, :quads, :glutes_and_calves],

  # J Exercises
  "JM Press" => [:triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :chest_and_triceps, :chest, :chest_pectorals, :shoulders, :upper_body, :core],

  "Jump Lunges" => [:legs, :lower_body, :quads, :quads_and_calves, :cardio, :hamstrings_and_glutes, :glutes_and_calves, :legs_quads_and_hamstrings, :legs_glutes_and_calves, :core, :entire_body],

  "Jump Rope" => [:entire_body, :cardio, :legs, :lower_body, :core, :core_abs_and_obliques, :shoulders, :shoulders_deltoids, :quads_and_calves, :glutes_and_calves, :forearms_and_grip_strength, :upper_body],

  "Jump Squats" => [:legs, :lower_body, :quads, :quads_and_calves, :legs_glutes_and_calves, :cardio, :hamstrings_and_glutes, :glutes_and_calves, :legs_quads_and_hamstrings, :core, :entire_body],

  "Jumping Jacks" => [:entire_body, :cardio, :legs, :lower_body, :shoulders, :shoulders_deltoids, :core, :quads, :hamstrings_and_glutes, :upper_body],

  "Jumps (Box)" => [:cardio, :legs, :lower_body, :quads, :quads_and_calves, :hamstrings_and_glutes, :glutes_and_calves, :core, :entire_body],

  "Jumps (Plyometric)" => [:cardio, :legs, :lower_body, :entire_body, :quads, :hamstrings_and_glutes, :glutes_and_calves, :core, :quads_and_calves],

  # K Exercises
  "Kettlebell Bottoms-Up Press" => [:forearms_and_grip_strength, :shoulders, :shoulders_deltoids, :core, :core_abs_and_obliques, :triceps, :upper_body, :back],

  "Kettlebell Clean and Jerk" => [:entire_body, :shoulders, :shoulders_deltoids, :legs, :lower_body, :core, :core_abs_and_obliques, :back, :triceps, :quads, :hamstrings_and_glutes, :forearms_and_grip_strength, :cardio],

  "Kettlebell Swings" => [:entire_body, :hamstrings_and_glutes, :hamstrings, :shoulders, :shoulders_deltoids, :core, :core_abs_and_obliques, :cardio, :legs, :lower_body, :glutes_and_calves, :back, :quads, :forearms_and_grip_strength],

  "Kickboxing" => [:cardio, :entire_body, :legs, :lower_body, :core, :core_abs_and_obliques, :shoulders, :upper_body, :quads, :hamstrings_and_glutes, :chest, :triceps],

  "Knee Raises" => [:core, :core_abs_and_obliques, :legs, :quads, :shoulders, :forearms_and_grip_strength],

  # L Exercises
  "L-Sits" => [:core, :core_abs_and_obliques, :shoulders, :shoulders_deltoids, :triceps, :arms_biceps_and_triceps, :upper_body, :forearms_and_grip_strength, :back],

  "Landmine Press" => [:chest, :chest_pectorals, :shoulders, :shoulders_deltoids, :push_chest_shoulders_triceps, :core, :core_abs_and_obliques, :triceps, :upper_body, :legs, :entire_body],

  "Landmine Rows" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :core, :core_abs_and_obliques, :shoulders, :upper_body, :forearms_and_grip_strength, :legs],

  "Lat Pulldown" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :upper_body, :shoulders, :shoulders_deltoids, :core, :forearms_and_grip_strength],

  "Lat Pulldown Machine" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :forearms_and_grip_strength, :core],

  "Lateral Band Walks" => [:hamstrings_and_glutes, :legs_glutes_and_calves, :legs, :lower_body, :glutes_and_calves, :quads, :core, :hamstrings],

  "Lateral Lunges" => [:legs, :lower_body, :hamstrings_and_glutes, :quads, :quads_and_calves, :glutes_and_calves, :legs_quads_and_hamstrings, :legs_glutes_and_calves, :core, :hamstrings],

  "Lateral Raises" => [:shoulders, :shoulders_deltoids, :push_chest_shoulders_triceps, :upper_body, :triceps, :core, :back],

  "Leg Curls" => [:hamstrings, :hamstrings_and_glutes, :legs, :lower_body, :legs_quads_and_hamstrings, :glutes_and_calves, :legs_glutes_and_calves],

  "Leg Curls (Lying)" => [:hamstrings, :hamstrings_and_glutes, :legs, :lower_body, :legs_quads_and_hamstrings, :glutes_and_calves, :legs_glutes_and_calves],

  "Leg Curls (Machine)" => [:hamstrings, :hamstrings_and_glutes, :legs, :lower_body, :legs_quads_and_hamstrings, :glutes_and_calves, :legs_glutes_and_calves],

  "Leg Curls (Nordic)" => [:hamstrings, :hamstrings_and_glutes, :legs, :lower_body, :legs_quads_and_hamstrings, :glutes_and_calves, :legs_glutes_and_calves, :core, :quads],

  "Leg Curls (Seated)" => [:hamstrings, :hamstrings_and_glutes, :legs, :lower_body, :legs_quads_and_hamstrings, :glutes_and_calves, :legs_glutes_and_calves],

  "Leg Curls (Slider)" => [:hamstrings, :hamstrings_and_glutes, :legs, :lower_body, :legs_quads_and_hamstrings, :glutes_and_calves, :legs_glutes_and_calves, :core, :core_abs_and_obliques],

  "Leg Curls (Stability Ball)" => [:hamstrings, :hamstrings_and_glutes, :legs, :lower_body, :legs_quads_and_hamstrings, :glutes_and_calves, :legs_glutes_and_calves, :core, :core_abs_and_obliques],

  "Leg Curls (Standing)" => [:hamstrings, :hamstrings_and_glutes, :legs, :lower_body, :legs_quads_and_hamstrings, :glutes_and_calves, :legs_glutes_and_calves, :core],

  "Leg Extensions" => [:quads, :quads_and_calves, :legs, :lower_body, :legs_quads_and_hamstrings],

  "Leg Press" => [:legs, :lower_body, :quads, :quads_and_calves, :legs_quads_and_hamstrings, :hamstrings_and_glutes, :glutes_and_calves, :legs_glutes_and_calves, :hamstrings, :core],

  "Leg Press (Single-Leg)" => [:quads, :quads_and_calves, :legs, :lower_body, :hamstrings_and_glutes, :glutes_and_calves, :legs_quads_and_hamstrings, :legs_glutes_and_calves, :core, :hamstrings],

  "Leg Press Crunches" => [:core, :core_abs_and_obliques, :legs, :lower_body, :hamstrings_and_glutes, :quads],

  "Leg Raises" => [:core, :core_abs_and_obliques, :legs, :quads, :shoulders, :forearms_and_grip_strength, :back],

  "Leg Swings" => [:neck_and_mobility_stretching, :legs, :lower_body, :core, :core_abs_and_obliques, :hamstrings_and_glutes, :quads, :glutes_and_calves],

  "Low Rows (Cable)" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :forearms_and_grip_strength, :core],

  "Lu Raises" => [:shoulders, :shoulders_deltoids, :upper_body, :triceps, :core, :back],

  "Lunges (Curtsy)" => [:legs, :lower_body, :hamstrings_and_glutes, :quads, :quads_and_calves, :glutes_and_calves, :legs_quads_and_hamstrings, :legs_glutes_and_calves, :core, :hamstrings],

  "Lunges (Jump)" => [:legs, :lower_body, :quads, :quads_and_calves, :cardio, :hamstrings_and_glutes, :glutes_and_calves, :legs_quads_and_hamstrings, :legs_glutes_and_calves, :core, :entire_body],

  "Lunges (Lateral)" => [:legs, :lower_body, :quads, :quads_and_calves, :hamstrings_and_glutes, :glutes_and_calves, :legs_quads_and_hamstrings, :legs_glutes_and_calves, :core, :hamstrings],

  "Lunges (Reverse)" => [:legs, :lower_body, :quads, :quads_and_calves, :hamstrings_and_glutes, :glutes_and_calves, :legs_quads_and_hamstrings, :legs_glutes_and_calves, :core, :hamstrings],

  "Lunges (Walking)" => [:legs, :lower_body, :quads, :quads_and_calves, :legs_quads_and_hamstrings, :hamstrings_and_glutes, :glutes_and_calves, :legs_glutes_and_calves, :core, :hamstrings, :cardio],

  # M Exercises
  "Machine Rows" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :forearms_and_grip_strength, :core],

  "Machine Shoulder Press" => [:shoulders, :shoulders_deltoids, :push_chest_shoulders_triceps, :triceps, :arms_biceps_and_triceps, :upper_body, :core, :chest],

  "Man Makers" => [:entire_body, :shoulders, :shoulders_deltoids, :chest, :chest_pectorals, :legs, :lower_body, :core, :core_abs_and_obliques, :cardio, :triceps, :back, :quads, :hamstrings_and_glutes, :push_chest_shoulders_triceps],

  "Medicine Ball Slams" => [:entire_body, :core, :core_abs_and_obliques, :shoulders, :shoulders_deltoids, :cardio, :back, :triceps, :legs, :chest],

  "Military Press" => [:shoulders, :shoulders_deltoids, :push_chest_shoulders_triceps, :triceps, :arms_biceps_and_triceps, :upper_body, :core, :core_abs_and_obliques, :chest, :back, :legs, :entire_body],

  "Monster Walks" => [:hamstrings_and_glutes, :legs_glutes_and_calves, :legs, :lower_body, :glutes_and_calves, :quads, :core, :hamstrings],

  "Mountain Climbers" => [:entire_body, :core, :core_abs_and_obliques, :cardio, :shoulders, :shoulders_deltoids, :legs, :quads, :chest, :triceps, :upper_body],

  "Muscle-Ups" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :push_chest_shoulders_triceps, :chest, :chest_pectorals, :triceps, :arms_biceps_and_triceps, :core, :shoulders, :biceps, :upper_body, :entire_body, :forearms_and_grip_strength],

  # N Exercises
  "Neck Extension" => [:neck_and_mobility_stretching],

  "Neck Flexion" => [:neck_and_mobility_stretching, :core],

  "Neck Lateral Flexion" => [:neck_and_mobility_stretching, :core],

  "Neck Rotation" => [:neck_and_mobility_stretching, :shoulders],

  "Nordic Curls" => [:hamstrings, :hamstrings_and_glutes, :legs, :lower_body, :legs_quads_and_hamstrings, :glutes_and_calves, :legs_glutes_and_calves, :core, :quads, :entire_body],

  # O Exercises
  "Overhead Press" => [:shoulders, :shoulders_deltoids, :push_chest_shoulders_triceps, :triceps, :arms_biceps_and_triceps, :upper_body, :core, :core_abs_and_obliques, :chest, :back, :legs, :entire_body],

  "Overhead Tricep Extension" => [:triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :shoulders, :shoulders_deltoids, :upper_body, :core, :chest_and_triceps],

  # P Exercises
  "Pallof Press" => [:core, :core_abs_and_obliques, :shoulders, :shoulders_deltoids, :triceps, :chest, :back, :upper_body],

  "Pec Deck" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :upper_body, :shoulders, :shoulders_deltoids, :triceps],

  "Pec Deck Machine" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :upper_body, :triceps],

  "Pigeon Pose" => [:neck_and_mobility_stretching, :legs, :lower_body, :hamstrings_and_glutes, :glutes_and_calves, :core, :back],

  "Pike Push-Ups" => [:shoulders, :shoulders_deltoids, :push_chest_shoulders_triceps, :triceps, :arms_biceps_and_triceps, :upper_body, :core, :chest, :back],

  "Planks (Regular)" => [:core, :core_abs_and_obliques, :shoulders, :shoulders_deltoids, :triceps, :chest, :back, :upper_body, :glutes_and_calves, :legs],

  "Planks (Side)" => [:core, :core_abs_and_obliques, :shoulders, :shoulders_deltoids, :triceps, :chest, :back, :upper_body, :glutes_and_calves, :legs],

  "Plate Pinches" => [:forearms_and_grip_strength, :arms_biceps_and_triceps, :shoulders, :back],

  "Pogo Jumps" => [:quads_and_calves, :legs, :cardio, :lower_body, :glutes_and_calves, :quads, :hamstrings_and_glutes, :core, :entire_body],

  "Preacher Curl Machine" => [:biceps, :arms_biceps_and_triceps, :pull_back_biceps, :forearms_and_grip_strength, :upper_body, :back_and_biceps],

  "Press (Push)" => [:shoulders, :shoulders_deltoids, :push_chest_shoulders_triceps, :triceps, :arms_biceps_and_triceps, :upper_body, :core, :chest],

  "Press (Seated Dumbbell)" => [:shoulders, :shoulders_deltoids, :push_chest_shoulders_triceps, :triceps, :arms_biceps_and_triceps, :upper_body, :core, :chest],

  "Press (Single-Arm Dumbbell)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :triceps, :arms_biceps_and_triceps, :core, :core_abs_and_obliques, :shoulders, :upper_body],

  "Prone Y-T-W" => [:back, :back_lats_trapezius_rhomboids, :shoulders, :shoulders_deltoids, :upper_body, :pull_back_biceps, :triceps, :core],

  "Pull-Ups" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :upper_body, :shoulders, :shoulders_deltoids, :core, :forearms_and_grip_strength, :entire_body],

  "Pull-Ups (Assisted)" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :core, :forearms_and_grip_strength],

  "Pull-Ups (Towel)" => [:forearms_and_grip_strength, :back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :core],

  "Pull-Ups (Wide-Grip)" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :upper_body, :shoulders, :core, :forearms_and_grip_strength, :entire_body],

  "Pulldowns (Close-Grip)" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :forearms_and_grip_strength, :core],

  "Pulldowns (Lat)" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :forearms_and_grip_strength, :core],

  "Pulldowns (Reverse Grip)" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :forearms_and_grip_strength],

  "Pulldowns (Wide-Grip)" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :forearms_and_grip_strength, :core],

  "Pullovers" => [:chest, :chest_pectorals, :back, :back_lats_trapezius_rhomboids, :triceps, :arms_biceps_and_triceps, :shoulders, :shoulders_deltoids, :core, :upper_body, :pull_back_biceps],

  "Pulse Squats" => [:quads, :quads_and_calves, :legs, :lower_body, :hamstrings_and_glutes, :glutes_and_calves, :legs_quads_and_hamstrings, :legs_glutes_and_calves, :core],

  "Push Press" => [:shoulders, :shoulders_deltoids, :push_chest_shoulders_triceps, :legs, :lower_body, :core, :core_abs_and_obliques, :triceps, :upper_body, :quads, :hamstrings_and_glutes, :entire_body],

  "Push-Ups (Archer)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :triceps, :arms_biceps_and_triceps, :core, :core_abs_and_obliques, :shoulders, :upper_body, :back, :entire_body],

  "Push-Ups (Decline)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :triceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :core],

  "Push-Ups (Diamond)" => [:triceps, :arms_biceps_and_triceps, :chest, :chest_pectorals, :push_chest_shoulders_triceps, :shoulders, :upper_body, :core],

  "Push-Ups (Incline)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :triceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :core],

  "Push-Ups (Pike)" => [:shoulders, :shoulders_deltoids, :push_chest_shoulders_triceps, :triceps, :arms_biceps_and_triceps, :upper_body, :core, :chest, :back],

  "Push-Ups (Regular)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :triceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :core, :entire_body],

  "Push-Ups (Wide-Grip)" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :triceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :core],

  "Push-up to T" => [:entire_body, :chest, :chest_pectorals, :shoulders, :shoulders_deltoids, :core, :core_abs_and_obliques, :triceps, :back, :upper_body, :legs],

  "Pushdowns (Reverse-Grip)" => [:triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :upper_body, :biceps, :forearms_and_grip_strength],

  "Pushdowns (Tricep)" => [:triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :upper_body],

  "Pushdowns (Tricep Rope)" => [:triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :upper_body, :forearms_and_grip_strength],

  "Pushdowns (Tricep V-Bar)" => [:triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :upper_body],

  # Q Exercises
  "Quad Stretch" => [:neck_and_mobility_stretching, :legs, :lower_body, :quads, :quads_and_calves, :legs_quads_and_hamstrings],

  # R Exercises
  "Raises (Front)" => [:shoulders, :shoulders_deltoids, :push_chest_shoulders_triceps, :upper_body, :chest, :core, :triceps],

  "Raises (Lateral)" => [:shoulders, :shoulders_deltoids, :push_chest_shoulders_triceps, :upper_body, :triceps, :core, :back],

  "Raises (Lu)" => [:shoulders, :shoulders_deltoids, :upper_body, :triceps, :core, :back, :chest],

  "Raises (T-)" => [:shoulders, :shoulders_deltoids, :back, :back_lats_trapezius_rhomboids, :upper_body, :core, :triceps],

  "Raises (Y-)" => [:shoulders, :shoulders_deltoids, :back, :back_lats_trapezius_rhomboids, :upper_body, :core, :triceps],

  "Rear Delt Flyes" => [:shoulders, :shoulders_deltoids, :back, :back_lats_trapezius_rhomboids, :upper_body, :pull_back_biceps, :triceps, :core],

  "Reverse Flyes" => [:shoulders, :shoulders_deltoids, :back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :upper_body, :triceps, :core, :biceps],

  "Reverse Hypers" => [:hamstrings, :hamstrings_and_glutes, :back, :back_lats_trapezius_rhomboids, :lower_body, :legs, :glutes_and_calves, :legs_glutes_and_calves, :core],

  "Reverse Lunges" => [:hamstrings_and_glutes, :legs_glutes_and_calves, :legs, :lower_body, :quads, :quads_and_calves, :glutes_and_calves, :legs_quads_and_hamstrings, :core, :hamstrings],

  "Reverse Wrist Curls" => [:forearms_and_grip_strength, :arms_biceps_and_triceps],

  "Rice Bucket Training" => [:forearms_and_grip_strength, :arms_biceps_and_triceps],

  "Ring Dips" => [:chest, :chest_pectorals, :triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :shoulders, :shoulders_deltoids, :core, :core_abs_and_obliques, :upper_body, :back, :entire_body],

  "Rock Climbing" => [:forearms_and_grip_strength, :back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :shoulders, :shoulders_deltoids, :core, :core_abs_and_obliques, :legs, :lower_body, :biceps, :upper_body, :entire_body, :quads, :hamstrings_and_glutes],

  "Roman Chair Sit-Ups" => [:core, :core_abs_and_obliques, :legs, :quads, :shoulders],

  "Rope Climbing" => [:forearms_and_grip_strength, :back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :shoulders, :shoulders_deltoids, :biceps, :arms_biceps_and_triceps, :core, :core_abs_and_obliques, :legs, :upper_body, :entire_body],

  "Rope Climbs" => [:entire_body, :back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :shoulders, :shoulders_deltoids, :forearms_and_grip_strength, :core, :core_abs_and_obliques, :biceps, :legs, :upper_body, :triceps],

  "Rowing (Concept2)" => [:cardio, :back, :back_lats_trapezius_rhomboids, :legs, :lower_body, :entire_body, :pull_back_biceps, :shoulders, :core, :quads, :hamstrings_and_glutes, :biceps, :forearms_and_grip_strength],

  "Rowing (Machine)" => [:cardio, :back, :back_lats_trapezius_rhomboids, :legs, :lower_body, :entire_body, :pull_back_biceps, :shoulders, :core, :quads, :hamstrings_and_glutes, :biceps, :forearms_and_grip_strength],

  "Rowing (Water)" => [:cardio, :back, :back_lats_trapezius_rhomboids, :legs, :lower_body, :entire_body, :pull_back_biceps, :shoulders, :core, :quads, :hamstrings_and_glutes, :biceps, :forearms_and_grip_strength, :upper_body],

  "Rowing Machine" => [:entire_body, :cardio, :back, :back_lats_trapezius_rhomboids, :legs, :lower_body, :pull_back_biceps, :shoulders, :core, :quads, :hamstrings_and_glutes, :biceps, :forearms_and_grip_strength, :upper_body],

  "Rows (Barbell)" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :upper_body, :shoulders, :shoulders_deltoids, :core, :forearms_and_grip_strength, :legs, :hamstrings_and_glutes, :entire_body],

  "Rows (Cable)" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :upper_body, :shoulders, :shoulders_deltoids, :core, :forearms_and_grip_strength],

  "Rows (Chest-Supported)" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :shoulders, :shoulders_deltoids, :upper_body, :forearms_and_grip_strength],

  "Rows (Dumbbell)" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :upper_body, :shoulders, :shoulders_deltoids, :core, :forearms_and_grip_strength, :legs],

  "Rows (Hammer Strength)" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :forearms_and_grip_strength, :core],

  "Rows (Landmine)" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :core, :core_abs_and_obliques, :shoulders, :upper_body, :forearms_and_grip_strength, :legs, :entire_body],

  "Rows (Low Cable)" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :forearms_and_grip_strength, :core],

  "Rows (Machine)" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :forearms_and_grip_strength, :core],

  "Rows (Seated Cable)" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :forearms_and_grip_strength, :core],

  "Rows (Single-Arm)" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :core, :core_abs_and_obliques, :shoulders, :upper_body, :forearms_and_grip_strength],

  "Rows (Single-Arm Dumbbell)" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :core, :core_abs_and_obliques, :shoulders, :upper_body, :forearms_and_grip_strength, :legs],

  "Rows (T-Bar)" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :upper_body, :shoulders, :shoulders_deltoids, :core, :forearms_and_grip_strength, :legs, :entire_body],

  "Running (Interval)" => [:cardio, :legs, :lower_body, :core, :core_abs_and_obliques, :quads, :hamstrings_and_glutes, :glutes_and_calves, :quads_and_calves, :entire_body],

  "Running (Outdoor)" => [:cardio, :legs, :lower_body, :glutes_and_calves, :legs_glutes_and_calves, :quads, :hamstrings_and_glutes, :core, :entire_body, :quads_and_calves],

  "Running (Track)" => [:cardio, :legs, :lower_body, :quads, :quads_and_calves, :hamstrings_and_glutes, :glutes_and_calves, :core, :entire_body],

  "Running (Trail)" => [:cardio, :legs, :lower_body, :core, :core_abs_and_obliques, :quads, :hamstrings_and_glutes, :glutes_and_calves, :entire_body, :shoulders],

  "Russian Twists" => [:core, :core_abs_and_obliques, :shoulders, :arms_biceps_and_triceps, :back],

  # S Exercises
  "Sandbag Carries" => [:entire_body, :core, :core_abs_and_obliques, :shoulders, :shoulders_deltoids, :forearms_and_grip_strength, :legs, :lower_body, :back, :upper_body, :quads, :hamstrings_and_glutes, :glutes_and_calves],

  "Scarecrows" => [:shoulders, :shoulders_deltoids, :back, :back_lats_trapezius_rhomboids, :upper_body, :triceps, :core],

  "Scissors" => [:core, :core_abs_and_obliques, :legs, :quads, :hamstrings],

  "Seated Cable Row" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :upper_body, :shoulders, :shoulders_deltoids, :forearms_and_grip_strength, :core],

  "Seated Cable Row Machine" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :forearms_and_grip_strength, :core],

  "Seated Dumbbell Press" => [:shoulders, :shoulders_deltoids, :push_chest_shoulders_triceps, :triceps, :arms_biceps_and_triceps, :upper_body, :core, :chest],

  "Seated Spinal Twist" => [:neck_and_mobility_stretching, :core, :core_abs_and_obliques, :back, :back_lats_trapezius_rhomboids, :shoulders],

  "Shrugs" => [:shoulders, :shoulders_deltoids, :back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :upper_body, :forearms_and_grip_strength, :core],

  "Sissy Squats" => [:quads, :quads_and_calves, :legs, :lower_body, :core, :core_abs_and_obliques, :legs_quads_and_hamstrings, :glutes_and_calves],

  "Sit-Ups" => [:core, :core_abs_and_obliques, :legs, :quads],

  "Skull Crushers" => [:triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :upper_body, :core, :chest],

  "Sled Pushes" => [:entire_body, :cardio, :legs, :lower_body, :shoulders, :shoulders_deltoids, :core, :core_abs_and_obliques, :quads, :hamstrings_and_glutes, :glutes_and_calves, :chest, :triceps, :back],

  "Snatch" => [:entire_body, :shoulders, :shoulders_deltoids, :legs, :lower_body, :back, :back_lats_trapezius_rhomboids, :core, :core_abs_and_obliques, :quads, :hamstrings_and_glutes, :forearms_and_grip_strength, :triceps, :cardio, :upper_body],

  "Soccer" => [:cardio, :legs, :lower_body, :core, :core_abs_and_obliques, :quads, :hamstrings_and_glutes, :glutes_and_calves, :quads_and_calves, :entire_body, :shoulders],

  "Squeeze Press" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :triceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :core],

  "Squats (Barbell)" => [:legs, :lower_body, :legs_quads_and_hamstrings, :quads, :quads_and_calves, :core, :core_abs_and_obliques, :hamstrings_and_glutes, :glutes_and_calves, :legs_glutes_and_calves, :back, :shoulders, :entire_body],

  "Squats (Bulgarian Split)" => [:quads, :quads_and_calves, :legs_quads_and_hamstrings, :legs, :lower_body, :hamstrings_and_glutes, :glutes_and_calves, :legs_glutes_and_calves, :core, :hamstrings],

  "Squats (Cossack)" => [:legs, :lower_body, :quads, :quads_and_calves, :hamstrings_and_glutes, :glutes_and_calves, :legs_quads_and_hamstrings, :legs_glutes_and_calves, :core, :hamstrings],

  "Squats (Cyclist)" => [:legs, :lower_body, :quads, :quads_and_calves, :legs_quads_and_hamstrings, :hamstrings_and_glutes, :glutes_and_calves, :core],

  "Squats (Front)" => [:legs, :lower_body, :quads, :quads_and_calves, :legs_quads_and_hamstrings, :core, :core_abs_and_obliques, :shoulders, :shoulders_deltoids, :upper_body, :hamstrings_and_glutes, :glutes_and_calves, :back, :entire_body],

  "Squats (Goblet)" => [:legs, :lower_body, :quads, :quads_and_calves, :legs_quads_and_hamstrings, :forearms_and_grip_strength, :core, :shoulders, :upper_body, :hamstrings_and_glutes, :glutes_and_calves, :triceps, :entire_body],

  "Squats (Hack)" => [:quads, :quads_and_calves, :legs, :lower_body, :legs_quads_and_hamstrings, :hamstrings_and_glutes, :glutes_and_calves, :core],

  "Squats (Jump)" => [:legs, :lower_body, :quads, :quads_and_calves, :cardio, :hamstrings_and_glutes, :glutes_and_calves, :legs_quads_and_hamstrings, :legs_glutes_and_calves, :core, :entire_body],

  "Squats (Narrow)" => [:quads, :quads_and_calves, :legs, :lower_body, :legs_quads_and_hamstrings, :core, :hamstrings_and_glutes],

  "Squats (Pistol)" => [:legs, :lower_body, :quads, :quads_and_calves, :core, :core_abs_and_obliques, :hamstrings_and_glutes, :glutes_and_calves, :legs_quads_and_hamstrings, :legs_glutes_and_calves, :entire_body],

  "Squats (Pulse)" => [:quads, :quads_and_calves, :legs, :lower_body, :hamstrings_and_glutes, :glutes_and_calves, :legs_quads_and_hamstrings, :legs_glutes_and_calves, :core],

  "Squats (Regular)" => [:legs, :lower_body, :quads, :quads_and_calves, :hamstrings_and_glutes, :glutes_and_calves, :legs_quads_and_hamstrings, :legs_glutes_and_calves, :core, :hamstrings],

  "Squats (Sissy)" => [:legs, :quads, :quads_and_calves, :lower_body, :core, :core_abs_and_obliques, :legs_quads_and_hamstrings],

  "Squats (Sumo)" => [:legs, :lower_body, :hamstrings_and_glutes, :legs_quads_and_hamstrings, :legs_glutes_and_calves, :glutes_and_calves, :quads, :quads_and_calves, :core, :hamstrings],

  "Squats (Wide)" => [:quads, :quads_and_calves, :hamstrings_and_glutes, :legs, :lower_body, :glutes_and_calves, :legs_quads_and_hamstrings, :legs_glutes_and_calves, :core, :hamstrings],

  "Squat to Press" => [:entire_body, :legs, :lower_body, :shoulders, :shoulders_deltoids, :core, :core_abs_and_obliques, :quads, :hamstrings_and_glutes, :triceps, :push_chest_shoulders_triceps, :cardio],

  "Stairs (Climber)" => [:cardio, :legs, :lower_body, :glutes_and_calves, :legs_glutes_and_calves, :quads, :hamstrings_and_glutes, :core, :entire_body, :quads_and_calves],

  "Stairs (Master)" => [:cardio, :legs, :lower_body, :glutes_and_calves, :legs_glutes_and_calves, :quads, :hamstrings_and_glutes, :core, :entire_body, :quads_and_calves],

  "Stairs (Mill)" => [:cardio, :legs, :lower_body, :glutes_and_calves, :legs_glutes_and_calves, :quads, :hamstrings_and_glutes, :core, :entire_body, :quads_and_calves],

  "Star Jumps" => [:entire_body, :cardio, :legs, :lower_body, :shoulders, :shoulders_deltoids, :core, :quads, :hamstrings_and_glutes, :upper_body],

  "Step-Ups" => [:legs, :lower_body, :quads, :quads_and_calves, :hamstrings_and_glutes, :legs_glutes_and_calves, :glutes_and_calves, :legs_quads_and_hamstrings, :core, :hamstrings],

  "Step-Ups (High)" => [:quads, :quads_and_calves, :legs, :lower_body, :hamstrings_and_glutes, :glutes_and_calves, :legs_quads_and_hamstrings, :legs_glutes_and_calves, :core, :hamstrings],

  "Stress Ball Squeezes" => [:forearms_and_grip_strength, :arms_biceps_and_triceps],

  "Stretches (Calf)" => [:neck_and_mobility_stretching, :legs, :lower_body, :glutes_and_calves, :quads_and_calves],

  "Stretches (Chest)" => [:neck_and_mobility_stretching, :chest, :chest_pectorals, :shoulders, :shoulders_deltoids, :upper_body],

  "Stretches (Hamstring)" => [:neck_and_mobility_stretching, :legs, :lower_body, :hamstrings, :hamstrings_and_glutes, :legs_quads_and_hamstrings, :glutes_and_calves],

  "Stretches (Hip Flexor)" => [:neck_and_mobility_stretching, :legs, :lower_body, :quads, :core, :hamstrings_and_glutes],

  "Stretches (IT Band)" => [:neck_and_mobility_stretching, :legs, :lower_body, :quads, :hamstrings, :glutes_and_calves],

  "Stretches (Quad)" => [:neck_and_mobility_stretching, :legs, :lower_body, :quads, :quads_and_calves, :legs_quads_and_hamstrings],

    "Sumo Squats" => [:glutes_and_calves, :legs_glutes_and_calves, :hamstrings_and_glutes, :legs, :lower_body, :quads, :quads_and_calves, :legs_quads_and_hamstrings, :core, :hamstrings],

  "Superman" => [:back, :back_lats_trapezius_rhomboids, :hamstrings_and_glutes, :core, :core_abs_and_obliques, :glutes_and_calves, :shoulders, :legs, :lower_body, :hamstrings],

  "Svend Press" => [:chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :triceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :core],

  "Swimming" => [:entire_body, :cardio, :shoulders, :shoulders_deltoids, :back, :back_lats_trapezius_rhomboids, :core, :core_abs_and_obliques, :chest, :legs, :upper_body, :triceps, :pull_back_biceps],

  "Swimming (Backstroke)" => [:cardio, :back, :back_lats_trapezius_rhomboids, :shoulders, :shoulders_deltoids, :entire_body, :core, :legs, :triceps, :pull_back_biceps, :upper_body],

  "Swimming (Breaststroke)" => [:cardio, :chest, :chest_pectorals, :legs, :lower_body, :entire_body, :shoulders, :core, :quads, :hamstrings_and_glutes, :triceps, :upper_body],

  "Swimming (Butterfly)" => [:cardio, :shoulders, :shoulders_deltoids, :chest, :chest_pectorals, :core, :core_abs_and_obliques, :entire_body, :back, :triceps, :legs, :upper_body],

  "Swimming (Freestyle)" => [:cardio, :shoulders, :shoulders_deltoids, :back, :back_lats_trapezius_rhomboids, :entire_body, :core, :triceps, :legs, :pull_back_biceps, :upper_body],

  # T Exercises
  "T-Bar Row Machine" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :biceps, :arms_biceps_and_triceps, :shoulders, :upper_body, :forearms_and_grip_strength, :core],

  "Tabata" => [:cardio, :entire_body, :core, :legs, :upper_body, :shoulders, :chest, :back],

  "Tate Press" => [:triceps, :arms_biceps_and_triceps, :chest, :chest_pectorals, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :upper_body, :core],

  "Tennis" => [:cardio, :entire_body, :shoulders, :shoulders_deltoids, :core, :core_abs_and_obliques, :legs, :upper_body, :back, :chest, :triceps, :forearms_and_grip_strength],

  "Thread the Needle" => [:neck_and_mobility_stretching, :shoulders, :shoulders_deltoids, :back, :back_lats_trapezius_rhomboids, :core, :core_abs_and_obliques, :chest],

  "Thrusters" => [:entire_body, :legs, :lower_body, :shoulders, :shoulders_deltoids, :core, :core_abs_and_obliques, :cardio, :quads, :hamstrings_and_glutes, :triceps, :push_chest_shoulders_triceps, :chest, :back],

  "Tire Flips" => [:entire_body, :legs, :lower_body, :back, :back_lats_trapezius_rhomboids, :shoulders, :shoulders_deltoids, :core, :core_abs_and_obliques, :quads, :hamstrings_and_glutes, :glutes_and_calves, :cardio, :forearms_and_grip_strength, :chest, :triceps],

  "Torso Rotation Machine" => [:core, :core_abs_and_obliques, :back, :shoulders],

  "Treadmill (Incline)" => [:cardio, :legs, :lower_body, :hamstrings_and_glutes, :glutes_and_calves, :legs_glutes_and_calves, :quads, :core, :entire_body],

  "Treadmill (Running)" => [:cardio, :legs, :lower_body, :quads, :hamstrings_and_glutes, :glutes_and_calves, :core, :entire_body, :quads_and_calves],

  "Treadmill (Sprints)" => [:cardio, :legs, :lower_body, :core, :core_abs_and_obliques, :quads, :hamstrings_and_glutes, :glutes_and_calves, :entire_body, :quads_and_calves],

  "Treadmill (Walking)" => [:cardio, :legs, :lower_body, :glutes_and_calves, :quads, :hamstrings_and_glutes, :core],

  "Tricep Dip Machine" => [:triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :chest_and_triceps, :chest, :chest_pectorals, :shoulders, :upper_body],

  "Tricep Dips" => [:triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :chest, :chest_pectorals, :shoulders, :upper_body, :core],

  "Tricep Kickbacks" => [:triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :chest_and_triceps, :shoulders, :upper_body, :core, :back],

  "Tricep Pushdowns" => [:triceps, :arms_biceps_and_triceps, :push_chest_shoulders_triceps, :shoulders, :upper_body, :chest_and_triceps],

  "Turkish Get-Ups" => [:entire_body, :core, :core_abs_and_obliques, :shoulders, :shoulders_deltoids, :legs, :lower_body, :back, :triceps, :quads, :hamstrings_and_glutes, :forearms_and_grip_strength, :upper_body],

  # U Exercises
  "Upright Rows" => [:shoulders, :shoulders_deltoids, :push_chest_shoulders_triceps, :pull_back_biceps, :back, :back_lats_trapezius_rhomboids, :upper_body, :biceps, :triceps, :forearms_and_grip_strength, :core],

  # V Exercises
  "V-Ups" => [:core, :core_abs_and_obliques, :legs, :quads, :shoulders],

  # W Exercises
  "Walking" => [:cardio, :legs, :lower_body, :glutes_and_calves, :quads, :hamstrings_and_glutes, :core, :quads_and_calves],

  "Walking (Incline)" => [:cardio, :legs, :lower_body, :hamstrings_and_glutes, :glutes_and_calves, :legs_glutes_and_calves, :quads, :core, :quads_and_calves],

  "Walking (Power)" => [:cardio, :legs, :lower_body, :core, :core_abs_and_obliques, :quads, :hamstrings_and_glutes, :glutes_and_calves, :entire_body],

  "Wall Balls" => [:entire_body, :legs, :lower_body, :shoulders, :shoulders_deltoids, :core, :core_abs_and_obliques, :cardio, :quads, :hamstrings_and_glutes, :triceps, :chest, :back],

  "Wall Handstand" => [:shoulders, :shoulders_deltoids, :triceps, :arms_biceps_and_triceps, :core, :core_abs_and_obliques, :upper_body, :forearms_and_grip_strength, :back, :chest],

  "Wall Sits" => [:legs, :lower_body, :quads, :quads_and_calves, :legs_quads_and_hamstrings, :hamstrings_and_glutes, :glutes_and_calves, :core],

  "Water Jogging" => [:cardio, :legs, :lower_body, :core, :core_abs_and_obliques, :quads, :hamstrings_and_glutes, :glutes_and_calves, :entire_body],

  "Wood Chops" => [:entire_body, :core, :core_abs_and_obliques, :shoulders, :shoulders_deltoids, :back, :chest, :triceps, :legs, :upper_body],

  "Wrist Roller" => [:forearms_and_grip_strength, :arms_biceps_and_triceps, :shoulders],

  # Y Exercises
  "Yoga Poses" => [:neck_and_mobility_stretching, :core, :core_abs_and_obliques, :entire_body, :legs, :shoulders, :back, :chest, :hamstrings_and_glutes, :quads]

}.freeze

# 🆕 All available muscle groups for custom splits
CUSTOM_SPLIT_MUSCLES = EXERCISE_TAGS.values.flatten.uniq.freeze

# 🆕 Recovery day options for custom splits (3-10 days)
RECOVERY_OPTIONS = (3..10).to_a.freeze

# Recovery cycle durations (in days) per muscle group
TRAINING_CYCLE = {
  cardio: 0.67, #special case (not part of split plans)
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
   options: ["Unknown"] + (1..700).map { |kg| "#{kg} kg" } + ["bodyweight"],
   color: "yellow",
   css_class: "badge-weight"
 },
 # 🆕 NEW: Time badge for cardio duration
 time: {
   options: ["Unknown"] + (1..120).map { |min| "#{min} minute#{'s' if min > 1}" },
   color: "orange",
   css_class: "badge-time"
 },
 # 🆕 NEW: Energy badge for cardio calories
 energy: {
   options: ["Unknown"] + (10..750).step(10).map { |cal| "#{cal} calories" },
   color: "red",
   css_class: "badge-energy"
 },
 # 🆕 NEW: Distance badge for cardio - METERS ONLY
 distance: {
   options: ["Unknown"] + (5..1000).step(5).map { |m| "#{m} m" },
   color: "teal",
   css_class: "badge-distance"
 },
 reflection: {
  options: [
    "bombed out",
    "distracted today",
    "explosive power",
    "felt heavy",
    "felt the stretch",
    "form broke down",
    "good mind-muscle connection",
    "great pump",
    "just a fail",
    "left some in tank",
    "maxed out",
    "need less weight",
    "need more weight",
    "not feeling it",
    "perfect form",
    "personal best",
    "pushed to failure",
    "rushed the reps",
    "solid effort",
    "too easy",
    "1 of 2", "2 of 2",
    "1 of 3", "2 of 3", "3 of 3",
    "1 of 4", "2 of 4", "3 of 4", "4 of 4"
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
 time: { icon: "⏱️", description: "Duration" },
 energy: { icon: "🔥", description: "Calories burned" },
 distance: { icon: "📏", description: "Distance covered" },
 reflection: { icon: "💭", description: "Notes and feelings" }
}.freeze

# 🆕 NEW: Helper method to get exercises for a muscle group (FIXED for flattened structure)
def self.exercises_for_muscle_group(muscle_group)
  EXERCISE_TAGS.select { |exercise, muscle_groups| muscle_groups.include?(muscle_group) }.keys.sort
end

# 🆕 NEW: Get all available exercises (replaces old WORKOUTS.values.flatten)
def self.all_exercises
 EXERCISE_TAGS.keys.sort
end

# 🆕 NEW: Get cardio exercises specifically
def self.cardio_exercises
 exercises_for_muscle_group(:cardio)
end

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

# 🆕 Detect if an exercise is cardio-based (updated to use new structure)
def self.cardio_exercise?(exercise_name)
 return false unless exercise_name.present?
 cardio_exercises.include?(exercise_name)
end

# 🆕 Get appropriate badge types for an exercise
def self.badge_types_for_exercise(exercise_name)
 if cardio_exercise?(exercise_name)
   [:time, :distance, :weight, :energy]
 else
   [:status, :reps, :weight, :reflection]
 end
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

# FIXED: Updated for flattened EXERCISE_TAGS structure
def self.all_muscle_groups
  EXERCISE_TAGS.values.flatten.uniq
end

def self.recovery_days_for(muscle)
 TRAINING_CYCLE[muscle] || 5
end

end  # End of AppConstants class
