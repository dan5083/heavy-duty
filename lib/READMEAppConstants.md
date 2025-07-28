# class AppConstants
#  # Hardcoded user-facing split options (e.g. "3 day split")
# # SPLITS constant
# SPLITS = {
#  :"1_day_split" => [:entire_body],
#  :"2_day_split" => [:upper_body, :lower_body],
#  :"3_day_split" => [:push_chest_shoulders_triceps, :pull_back_biceps, :legs],
#  :"4_day_split" => [:upper_body, :lower_body, :push_chest_shoulders_triceps, :pull_back_biceps],
#  :"5_day_split" => [:chest_and_triceps, :back_and_biceps, :legs, :shoulders, :core],
#  :"6_day_split" => [:chest, :back, :legs, :shoulders, :arms_biceps_and_triceps, :core],
#  :"7_day_split" => [:chest, :back, :legs, :shoulders, :biceps, :triceps, :core],
#  :"8_day_split" => [:chest, :back, :quads_and_calves, :shoulders, :hamstrings_and_glutes, :biceps, :triceps, :core],
#  :"9_day_split" => [:chest, :back, :quads, :hamstrings, :glutes_and_calves, :shoulders, :biceps, :triceps, :core],
#  :"10_day_split" => [
#    :chest_pectorals,
#    :back_lats_trapezius_rhomboids,
#    :shoulders_deltoids,
#    :biceps,
#    :triceps,
#    :legs_quads_and_hamstrings,
#    :legs_glutes_and_calves,
#    :core_abs_and_obliques,
#    :forearms_and_grip_strength,
#    :neck_and_mobility_stretching
#  ]
# }.freeze


# # Flattened EXERCISE_TAGS hash with generous muscle group inclusion
# EXERCISE_TAGS = {
#   # A Exercises
#   "Ab Crunch Machine" => [:core, :core_abs_and_obliques],

#   "Ab Wheel Rollouts" => [:core, :core_abs_and_obliques, :shoulders, :shoulders_deltoids, :chest, :chest_pectorals, :triceps, :upper_body, :entire_body],

#   "Arnold Press" => [:shoulders, :shoulders_deltoids, :upper_body, :push_chest_shoulders_triceps, :triceps, :arms_biceps_and_triceps, :chest, :chest_pectorals, :core, :entire_body],

#   "Arm Circles" => [:shoulders, :shoulders_deltoids, :neck_and_mobility_stretching, :upper_body],

#   "Assault Bike" => [:entire_body, :cardio, :legs, :upper_body, :lower_body, :shoulders, :core, :quads, :hamstrings, :glutes_and_calves],

#   "Assisted Pull-Up Machine" => [:back, :back_lats_trapezius_rhomboids, :pull_back_biceps, :upper_body, :biceps, :arms_biceps_and_triceps, :shoulders, :shoulders_deltoids, :core, :forearms_and_grip_strength],

#   # excercises begginging with E-W abridged for AI chat seeding purposes, Hi Claude!

#   # Y Exercises
#   "Yoga Poses" => [:neck_and_mobility_stretching, :core, :core_abs_and_obliques, :entire_body, :legs, :shoulders, :back, :chest, :hamstrings_and_glutes, :quads]

# }.freeze

# # 🆕 All available muscle groups for custom splits
# CUSTOM_SPLIT_MUSCLES = EXERCISE_TAGS.values.flatten.uniq.freeze

# # 🆕 Recovery day options for custom splits (3-10 days)
# RECOVERY_OPTIONS = (3..10).to_a.freeze

# # Recovery cycle durations (in days) per muscle group
# TRAINING_CYCLE = {
#   cardio: 0.67, #special case (not part of split plans)
#  entire_body: 10,
#  upper_body: 6,
#  lower_body: 8,
#  push_chest_shoulders_triceps: 7,
#  pull_back_biceps: 7,
#  legs: 9,
#  chest_and_triceps: 6,
#  back_and_biceps: 6,
#  shoulders: 5,
#  core: 3,
#  chest: 6,
#  back: 7,
#  arms_biceps_and_triceps: 4,
#  quads_and_calves: 9,
#  hamstrings_and_glutes: 9,
#  biceps: 3,
#  triceps: 3,
#  quads: 8,
#  hamstrings: 8,
#  glutes_and_calves: 10,
#  chest_pectorals: 6,
#  back_lats_trapezius_rhomboids: 7,
#  shoulders_deltoids: 5,
#  legs_quads_and_hamstrings: 9,
#  legs_glutes_and_calves: 10,
#  core_abs_and_obliques: 3,
#  forearms_and_grip_strength: 2,
#  neck_and_mobility_stretching: 4
# }.freeze

# # 🆕 Simplified CLAUSE_LIBRARY with discrete ranges
# CLAUSE_LIBRARY = {
#  status: {
#    options: ["Working set", "Warmup set", "Drop set", "Super set", "Heavy set", "Light set"],
#    color: "blue",
#    css_class: "badge-status"
#  },
#  reps: {
#    options: (1..35).to_a,
#    color: "green",
#    css_class: "badge-reps"
#  },
#  weight: {
#    options: (1..300).to_a,
#    color: "yellow",
#    css_class: "badge-weight"
#  },
#  # 🆕 NEW: Time badge for cardio duration
#  time: {
#    options: (1..120).map { |min| "#{min} minute#{'s' if min > 1}" },
#    color: "orange",
#    css_class: "badge-time"
#  },
#  # 🆕 NEW: Energy badge for cardio calories
#  energy: {
#    options: (10..750).step(10).map { |cal| "#{cal} calories" },
#    color: "red",
#    css_class: "badge-energy"
#  },
#  reflection: {
#   options: [
#     "bombed out",
#     "distracted today",
#     "explosive power",
#     "felt heavy",
#     "felt the stretch",
#     "form broke down",
#     "good mind-muscle connection",
#     "great pump",
#     "just a fail",
#     "left some in tank",
#     "maxed out",
#     "need less weight",
#     "need more weight",
#     "not feeling it",
#     "perfect form",
#     "personal best",
#     "pushed to failure",
#     "rushed the reps",
#     "solid effort",
#     "too easy",
#     "1 of 2", "2 of 2",
#     "1 of 3", "2 of 3", "3 of 3",
#     "1 of 4", "2 of 4", "3 of 4", "4 of 4"
#    ],
#    color: "purple",
#    css_class: "badge-reflection"
#  }
# }.freeze

# # 🆕 Badge type definitions and utilities
# BADGE_TYPES = {
#  status: { icon: "🏃", description: "Set type (Working, Drop, etc.)" },
#  reps: { icon: "🔢", description: "Repetition count" },
#  weight: { icon: "⚖️", description: "Weight used" },
#  time: { icon: "⏱️", description: "Duration" },
#  energy: { icon: "🔥", description: "Calories burned" },
#  reflection: { icon: "💭", description: "Notes and feelings" }
# }.freeze

# # 🆕 NEW: Helper method to get exercises for a muscle group (FIXED for flattened structure)
# def self.exercises_for_muscle_group(muscle_group)
#   EXERCISE_TAGS.select { |exercise, muscle_groups| muscle_groups.include?(muscle_group) }.keys.sort
# end

# # 🆕 NEW: Get all available exercises (replaces old WORKOUTS.values.flatten)
# def self.all_exercises
#  EXERCISE_TAGS.keys.sort
# end

# # 🆕 NEW: Get cardio exercises specifically
# def self.cardio_exercises
#  exercises_for_muscle_group(:cardio)
# end

# # 🆕 Helper methods for badge system
# def self.badge_options_for(type)
#  CLAUSE_LIBRARY.dig(type.to_sym, :options) || []
# end

# def self.badge_class_for(type)
#  CLAUSE_LIBRARY.dig(type.to_sym, :css_class) || "badge-default"
# end

# def self.badge_color_for(type)
#  CLAUSE_LIBRARY.dig(type.to_sym, :color) || "gray"
# end

# def self.all_badge_types
#  BADGE_TYPES.keys
# end

# # 🆕 Helper methods for time/distance generation
# def self.generate_time_options
#  options = []

#  # Seconds: 15, 30, 45 for short intervals
#  [15, 30, 45].each { |sec| options << "#{sec} seconds" }

#  # Minutes: 1-60 for main cardio sessions
#  (1..60).each { |min| options << "#{min} minute#{'s' if min > 1}" }

#  # Hours: 1-3 for long endurance sessions
#  (1..3).each { |hour| options << "#{hour} hour#{'s' if hour > 1}" }

#  options
# end

# def self.generate_distance_options
#   options = []

#   # Meters for shorter distances
#   [50, 100, 200, 400, 800, 1000].each { |m| options << "#{m}m" }

#   # Kilometers for running/cycling
#   [0.5, 1, 1.5, 2, 2.5, 3, 5, 10, 15, 20, 25, 30, 42.2].each { |km|
#     options << "#{km}km"
#   }

#   # Miles for those who prefer imperial
#   [0.5, 1, 1.5, 2, 3, 5, 10, 13.1, 26.2].each { |miles|
#     options << "#{miles} mile#{'s' if miles != 1}"
#   }

#   options
# end

# # 🆕 Detect if an exercise is cardio-based (updated to use new structure)
# def self.cardio_exercise?(exercise_name)
#  return false unless exercise_name.present?
#  cardio_exercises.include?(exercise_name)
# end

# # 🆕 Get appropriate badge types for an exercise
# def self.badge_types_for_exercise(exercise_name)
#  if cardio_exercise?(exercise_name)
#    [:time, :energy]
#  else
#    [:status, :reps, :weight, :reflection]
#  end
# end

# # Mapping from internal symbols to display strings
# LABELS = {
#  entire_body: "Entire Body",
#  upper_body: "Upper Body",
#  lower_body: "Lower Body",
#  push_chest_shoulders_triceps: "Push (Chest, Shoulders, Triceps)",
#  pull_back_biceps: "Pull (Back, Biceps)",
#  legs: "Legs",
#  chest_and_triceps: "Chest & Triceps",
#  back_and_biceps: "Back & Biceps",
#  shoulders: "Shoulders",
#  core: "Core",
#  chest: "Chest",
#  back: "Back",
#  arms_biceps_and_triceps: "Arms (Biceps & Triceps)",
#  quads_and_calves: "Quads & Calves",
#  hamstrings_and_glutes: "Hamstrings & Glutes",
#  biceps: "Biceps",
#  triceps: "Triceps",
#  quads: "Quads",
#  hamstrings: "Hamstrings",
#  glutes_and_calves: "Glutes & Calves",
#  chest_pectorals: "Chest (Pectorals)",
#  back_lats_trapezius_rhomboids: "Back (Lats, Trapezius, Rhomboids)",
#  shoulders_deltoids: "Shoulders (Deltoids)",
#  legs_quads_and_hamstrings: "Legs - Quads & Hamstrings",
#  legs_glutes_and_calves: "Legs - Glutes & Calves",
#  core_abs_and_obliques: "Core (Abs & Obliques)",
#  forearms_and_grip_strength: "Forearms & Grip Strength",
#  neck_and_mobility_stretching: "Neck & Mobility/Stretching",
#  custom_split: "Custom Split",
#  :"1_day_split" => "1 Day Split",
#  :"2_day_split" => "2 Day Split",
#  :"3_day_split" => "3 Day Split",
#  :"4_day_split" => "4 Day Split",
#  :"5_day_split" => "5 Day Split",
#  :"6_day_split" => "6 Day Split",
#  :"7_day_split" => "7 Day Split",
#  :"8_day_split" => "8 Day Split",
#  :"9_day_split" => "9 Day Split",
#  :"10_day_split" => "10 Day Split"
# }.freeze

# # Utility methods
# def self.label_for(symbol)
#  LABELS[symbol] || symbol.to_s.humanize
# end

# # FIXED: Updated for flattened EXERCISE_TAGS structure
# def self.all_muscle_groups
#   EXERCISE_TAGS.values.flatten.uniq
# end

# def self.recovery_days_for(muscle)
#  TRAINING_CYCLE[muscle] || 5
# end

# end
