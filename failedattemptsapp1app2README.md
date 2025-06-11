## 🧭 Part 1: Project Compass – polyrythmic-trainer

### 💡 Purpose

**Polyrythmic-Trainer** is a recovery-aware training organizer built for serious and self-directed lifters.

It helps users build and track their own custom workout schedules — based on chosen splits, exercises,
and intensity. It intelligently managing recovery timelines for each muscle group.

The system monitors how long each muscle has been resting, suggests what’s ready to train next, using boolians and time.
*The app promotes well rehearsed sets, and adequate recovery time*

*Polyrythmic-Trainer* enhances mental clarity by always showing you what’s coming up next in your split, keeping your next target muscle at the front of your focus before you even hit the gym.

**Behind the scenes, the app uses overlapping recovery cycles; as the number of cells in each muscle group varies greatly, so do their *periods* of recovery.**

---

### 🎯 Goals (MVP)

-  Allow users to select a classic 1–10 day split
-  Allow users to assign exercises to each split day (from hardcoded `WORKOUTS` scroll 2 line 251 approx)
-  Build a visual calendar or rhythm-style timeline of upcoming sessions
-  Dynamically sequence sessions to respect per-muscle recovery timing
-  Prevent overtraining via smart avoidance of synergistic muscle overlap
-  Allow users to set per-exercise details (sets, reps, RPE/intensity)
-  Track only completed workouts in recovery cycle logic
-  Allow user to skip scheduled muscle groups without marking them as worked
-  Show alternate “ready” muscle groups for impromptu sessions


---

### 👥 Target Users

- **Primary**: Advanced lifters who design their own workouts and want intelligent recovery tracking, split planning, and organizational clarity
- **Secondary**: Intermediate lifters transitioning to self-programmed training who want help managing split structure, muscle recovery, and workout tracking

---

### ⚙️ Core Concepts

- **SplitPlan**: A user-defined structure (e.g. 6-day split) reflecting their training cadence
- **SplitDay**: One day of that plan, linked to specific muscle group(s)
- **Workout**: A specific exercise chosen by the user for that day’s target(s)
- **WorkoutLog**: A record of actual performance — only completed workouts contribute to recovery tracking
- **MuscleRecoveryStatus**: Logic that determines readiness for each muscle group based on real workout logs and training cycles
- **AppConstants**: Centralized config for all valid splits, workouts, muscle labels, and recovery durations

app/
├── models/
│   ├── user.rb                          # ✅ has_many :split_plans, :workout_logs
│   ├── split_plan.rb                    # ✅ belongs_to :user, has_many :split_days
│   ├── split_day.rb                     # ✅ belongs_to :split_plan, has_many :workouts
│   ├── workout.rb                       # ✅ belongs_to :split_day, has_many :workout_logs
│   └── workout_log.rb                   # ✅ belongs_to :user, :workout (actual completed session)
|
├── frontend/controllers/                # 💡 StimulusJS controllers for dynamic frontend behavior
│   ├── chart-controller.js             # 📊 controls chart rendering (e.g. recovery graphs)
│   ├── hello-controller.js             # 👋 default/example Stimulus controller (starter template)
│   ├── log-builder-controller.js       # 🏋️ build workout logs (sets, reps, RPE selection)
│   └── split-selector-controller.js    # 🗂️  controls split selection UI (e.g. plan/day preview)
|
├── controllers/
│   ├── users_controller.rb              # ✅ user logs + muscle readiness
│   ├── split_plans_controller.rb        # ✅ split selection, create, show
│   ├── split_days_controller.rb         # ✅ per-day muscle config
│   ├── dashboard_controller.rb          # ✅ readiness + recovery schedule
│   ├── workouts_controller.rb           # ✅ add/edit workouts to days, show exercise detail
│   ├── workout_logs_controller.rb       # ✅ log sets/reps/RPE (scoped to workout)
│   └── training_archive_controller.rb   # ✅ global archive view (by muscle/date)
│
├── helpers/
│   ├── application_helper.rb       # ✅ global view helpers
│   ├── recovery_helper.rb          # ✅ readiness_label, status_badge for recovery UI
│   ├── split_days_helper.rb        # ✅ helpers for split day views or formatting
│   ├── split_plans_helper.rb       # ✅ helpers for split plan display or utilities
│   ├── training_archive_helper.rb  # ✅ helpers for archived training data display
│   └── workouts_helper.rb          # ✅ helpers for workout views, formatting
│
├── views/
│   ├── users/
│   │   └── show.html.erb                # ✅ recovery dashboard (per-user)
│
│   ├── split_plans/
│   │   ├── index.html.erb               # ✅ list of plans
│   │   ├── new.html.erb                 # ✅ split selector with preview
│   │   ├── initialize_recovery.html.erb # ✅
│   │   └── show.html.erb                # ✅ split viewer (log status, recovery cards)
│
│   ├── split_days/
│   │   ├── edit.html.erb                # ✅ toggle muscle config or workouts
│   │   └── show.html.erb                # ✅ per-day workout card view
│
│   ├── workouts/
│   │   ├── new.html.erb                 # ✅ assign exercise
│   │   ├── show.html.erb                # ✅ exercise detail view (RPE, history)
│   │   └── _form.html.erb               # ✅ shared workout form
│
│   ├── workout_logs/
│   │   └── new.html.erb                 # ✅ log performance (sets, reps, RPE)
│
│   ├── dashboard/
│   │   ├── _muscle_countdown.html.erb   # ✅ recovery tile partial
│   │   └── index.html.erb               # ✅ “what's trainable” view
│
│   ├── training_archive/
│   │   └── index.html.erb               # ✅ full historical log (by muscle/date)
│
│   └── shared/
│       ├── _benchmark_panel.html.erb    # ✅
│       ├── _workout_log_row.html.erb    # ✅ table row partial for logs
│       ├── _navbar.html.erb             # ✅ partial for navbars
│       └── _workout_card.html.erb       # ✅ card-style layout for workouts
|
├── spec/
│   ├── factories/
│   │   ├── users.rb                     # ✅ user factory
│   │   ├── split_plans.rb               # ✅ split plan factory
│   │   ├── split_days.rb                # ✅ split day factory
│   │   ├── workouts.rb                  # ✅ workout factory
│   │   └── workout_logs.rb              # ✅ workout log factory
│
│   ├── logic/
│   │   └── muscle_recovery_status_spec.rb # ✅ unit specs for recovery logic
│
│   ├── models/
│   │   ├── user_spec.rb                 # ✅ association specs
│   │   ├── split_plan_spec.rb           # ✅ association specs
│   │   ├── split_day_spec.rb            # ✅ association specs
│   │   ├── workout_spec.rb              # ✅ association specs
│   │   └── workout_log_spec.rb          # ✅ association specs
│
│   ├── requests/
│   │   ├── split_plans_spec.rb          # ✅ system test: create/view SplitPlan
│   │   ├── workout_logs_spec.rb         # ✅ system test: log/display completed workouts
│   │   └── dashboard_spec.rb            # ✅ “What can I train?” reflects readiness
│   │
│   ├── rails_helper.rb                  # ✅ RSpec Rails setup
│   └── spec_helper.rb                   # ✅ Core RSpec config
|
├── lib/
│   └── app_constants.rb                 # ✅ SPLITS, WORKOUTS, LABELS, TRAINING_CYCLE
|
├── logic/
│   ├── recovery_tracker.rb              # ✅ recovery countdown logic
│   └── muscle_recovery_status.rb        # ✅ per-muscle readiness engine
|
├── presenters/
│   ├── split_day_presenter.rb           # ✅ formats SplitDay layout
│   └── workout_presenter.rb             # ✅ formats workout name, reps, logs
│   └── workout_log_presenter.rb         # ✅ formats workout logs
|
├── seeds.rb
<!--    this all got deleted
javascript/
├── application.js                    # ✅ Bootstraps Stimulus app and loads all controllers
└── controllers/
    ├── chart-controller.js          # ✅ Chart.js visualizations (recovery rhythm, trends)
    ├── hello-controller.js          # ✅ Demo or test controller (Stimulus default)
    ├── index.js                     # ✅ Loads and registers all Stimulus controllers
    ├── log-builder-controller.js    # ✅
    └── split-selector-controller.js # ✅ Interactive UI for selecting split -->



### 🛠️ Part 2: TODO Checklist (Chronological, Finalized)

#### ✅ Initial Setup & Foundational Work

- ✅ Create fresh Rails app (`rails new polyrythmic-trainer`)
- ✅ Push to GitHub (`gh repo create polyrythmic-trainer`)
- ✅ Create initial `README.md` with clarified vision, goals, and architecture
- ✅ Remove deprecated services (`predefined_split_generator.rb`, `polyrhythmic_split_generator.rb`)
- ✅ Set up `AppConstants` PORO with symbol-driven `SPLITS`, `WORKOUTS`, `LABELS`, and `TRAINING_CYCLE`

---

#### 🔜 Routing & Conventions

- Define RESTful routes for:
  - [✅] `split_plans` (index, new, create, show, destroy)
  - [✅] `split_days` (nested under plans: show, update)
  - [✅] `workouts` (nested under days: new, create, update, destroy)
  - [✅] `workout_logs` (nested under workouts: new, create, index)
  - [✅] Ensure all controllers follow Rails resource conventions

---

### ✅ Foundational Setup
- [✅] Generate models: `SplitPlan`, `SplitDay`, `Workout` (with associations and migrations)
- [✅] Add `simple_form` with Bootstrap config
- [✅] Install Bootstrap 5 (via gem or CDN)
- [✅] Set up Hotwire (Turbo + Stimulus – Rails 7 default)
- [✅] Install Chart.js (via CDN — verified rendering in Stimulus controller)
- [✅] Create folders for `logic/`, `presenters/`, and `services/`
- [✅] Generate model: `User`, with controller and `has_many` setup
- [✅] Add `user_id` to `SplitPlan`, and `muscle_group` to `SplitDay` and `Workout`
- [✅] Generate `WorkoutLog` model with associations
- [✅] Seed with Dan’s real 8-day workout history (May 19–26)

### ✅ Core Logic
- [✅] Finalize full `TRAINING_CYCLE` for all 29 muscle symbols (glutes normalized to 10)
- [✅] Build `WorkoutLog` model to capture completed workout sessions
- [✅] Implement `MuscleRecoveryStatus` in `logic/` to determine per-muscle readiness
- [✅] Use real workout logs (not scheduled plans) to drive recovery state
- [✅] (Optional) Implement `recovery_tracker.rb` for passive cooldown simulation

---

#### 🔜 User Input Features

- [✅] Let users select a predefined split (1–10 day structure) via dynamic UI (new.html.erb, Stimulus controller, create action)     with live preview and SplitDay generation.
- [✅] Let users assign exercises per SplitDay (from `WORKOUTS`)
- [✅]  Let users log: sets, reps, RPE (intensity), and notes per workout
- [✅] Provide “What can I train today?” feature based on `MuscleRecoveryStatus`
- [✅] Implement toggle-based exercise selection per SplitDay (prevents duplicates by design)

---

#### 🔜 UI & UX (Figma-aligned)

  - [✅] Dashboard view (countdown list of muscle groups, sorted by readiness)
  - [✅] Schedule and n-day forcast (visual recovery status with timers per muscle)
  - [✅] Exercise detail page (sets, reps, intensity, notes + recovery countdown)
  - [✅] Archive/log (previous workouts by muscle or date)

#### 🔜 Apply Rails ActionView and LeWagon conventions:
  - [✅] Ensure use of `simple_form` for all input forms
  - [✅] Use partials for shared components (e.g., `_workout_card`, `_muscle_countdown`)
  - [✅] Use helpers or presenters for recovery states, countdown timers, RPE displays
  - [✅] Display "next-up" focus muscle (the muscle that will be ready soonest)

---

🔜 Testing
- [✅] Add model specs: SplitPlan, SplitDay, Workout, WorkoutLog
- [✅] Add logic specs: MuscleRecoveryStatus
- [✅] Test logic coverage:
  - [✅] Muscles only recover after completion is logged
  - [✅] “What can I train?” reflects readiness correctly
- [✅] Add system/route tests:
  - [✅] Creating and viewing a SplitPlan
  - [✅] Logging and displaying completed workouts



🔜 Quality & Enhancements
- [✅] Centralize domain config in `AppConstants` (fully symbol-driven)
- [✅] Add Presenters for `SplitDay`, `Workout`, `WorkoutLog`

- [✅] Add Devise for user authentication and account handling
- [✅] Limit recovery view to only muscle groups in current user’s split


### ✅ Split Planning + Recovery Initialization

- [✅] Let user select a split plan from constants
- [✅] Show split breakdown (Workout 1: ..., Workout 2: ...) before confirming
- [✅] Create split_days from selected structure
- [✅] Redirect to post-plan recovery form after creation
- [✅] Allow user to enter last training date per muscle group
- [✅] Persist training data as seeded WorkoutLogs
- [✅] Skip option if no recent workouts

### Navbar Implementation
[✅] Create shared/_navbar.html.erb partial
[✅] Insert navbar into application.html.erb
[✅] Update shared/_navbar.html.erb to ensure logout link uses method: :delete

### 🐞 Recovery Seeding Flow Fix

[✅] Update `initialize_recovery` in `split_plans_controller.rb` to only render the form (no logic)
[✅] Move recovery log creation into `submit_recovery` (POST handler)


### 🧭 Sprint 3: Clarify Views, Simplify Logging, Respect the Split
🧠 View Role Fixes
[✅] Rename Dashboard h1 to "Training Dashboard"
[✅] Rename Profile h1 to "Training Log"
[✅] Remove recovery status blocks from Profile view
[✅] Move log display fully into Profile (and out of Dashboard)
[🔄] Confirm Profile only shows logs, not readiness
🛈 Waiting on full WorkoutLog content (user-entered strings) for meaningful validation

### 🚫 Remove Status Labels (Recovering / Overtrained)
[✅] Remove :overtrained, :recovering, :ready display logic
[✅] Replace with:

 “Good to Go”

 “Ready in Xd Yh Zm”
[✅] Update badges and text in recovery helpers / views

### 📝 Logging Refactor — Freeform Entry
[✅] Ensure WorkoutLog has a text field (e.g. details)
[✅] Remove sets, reps, rpe fields from log form
[✅] Replace with single text_area labeled “What did you do?”

### 🧠 Beat Your Best (Schema + Logic Overhaul)
**Goal:** Use `Workout.details` as the saved benchmark performance

[✅] Remove `sets`, `reps`, `rpe`, `notes`, and `intensity` from `workouts` table
[✅] Ensure `details:text` remains on `workouts` (as the benchmark field)
[✅] Update seeds to set `Workout.details` for each created workout
[✅] Log only `WorkoutLog.details` (freeform effort input)
[✅] After starting workout, and again after logging, show benchmark (`Workout.details`) for comparison
[✅] Add “Beat It” button to promote latest `WorkoutLog.details` → `Workout.details`
[✅] On workout page, show both benchmark and most recent log side-by-side

---

###  UI Recovery Enhancements
[✅] Split-aware filtering across Dashboard, Schedule, and Log views
[✅] Schedule view shows only relevant muscles, with ✅ / ⏳ icons and readiness tooltips
[✅] “Next-Up” alert displays upcoming muscle with countdown and date

---

🐛 **Bugfixes & Stability**
[✅] Fixed archive crash (replaced broken `simple_form_with`)
[✅] Scoped logs to current user, added “no logs” fallback
[✅] Repaired symbol-vs-string mismatch in dashboard logic

💡 **Dashboard Enhancements**
[✅] Added fallback alert if no muscle data present
[✅] Showed countdown tiles for recovery status
[✅] Added “Start This Workout” button per muscle
[✅] Fixed date/time comparison bug in countdown partial

📋 **Workout Detail View**
[✅] Added "Start This Workout" CTA
[✅] Preserved benchmark + log history + promote action

🗑️ **Schedule Cleanup**
[✅] Removed DashboardController#schedule action
[✅] Deleted views/dashboard/schedule.html.erb
[✅] Deleted app/helpers/dashboard_helper.rb
[✅] Removed /schedule route from routes.rb
[✅] Removed /schedule link from navbar

🧠 **Multi-Step Workout Logging**
[✅] Turbo/Stimulus flow replaces workout_logs#new
[✅] Step 1: Select exercises from WORKOUTS
[✅] Step 2: Enter freeform set notes
[✅] Serialize to JSON → store in WorkoutLog.details
[✅] Controller parses JSON, formats or gracefully falls back
Views
[✅] new.html.erb uses Turbo Frames
[✅] Dynamic set inputs via Stimulus
[✅] Hidden JSON field injected before submit
[✅] Preview + Submit handled inline
🔥 Benchmark Display
[✅] Parses structured JSON logs into readable lists
[✅] Falls back to simple_format(details) if invalid/legacy
⚙️ Stimulus Controller
[✅] Tracks exercise selection
[✅] Adds/removes set fields per exercise
[✅] Serializes structure into hidden field on submit

🧠 Multi-Step Workout Logging rollback and replace (remove Turbo)

🧠 Single-Page Workout Logging Rollback
[✅] Replaces multi-step Turbo/Stimulus flow with single-page Stimulus-enhanced form
[✅] Merge exercise selection + set entry into workout_logs#new
[✅] Remove all <turbo-frame> usage and .turbo_stream.erb logic
[✅] Retain log-builder Stimulus controller (handles sets, JSON serialization)
[✅] Render all exercises inline
[✅] Use checkbox toggle + Stimulus to show/hide sets per exercise
[✅] Serialize entire form to JSON → store in WorkoutLog.details

🔥 Benchmark + Log Display
[✅] Parse JSON into readable comparisons
[✅] Fallback to simple_format(details) if structure is invalid or legacy

⚙️ Stimulus Controller
[✅] Manages set entry UI inline
[✅] Tracks toggled exercises
[✅] Serializes full log to hidden JSON field on submit

🎙️ Voice-to-Text Logging (Click vs Hold Support)
[✅] Update `new.html.erb` → replace mic button with a single `+ Add` button (one per card) using `mousedown``mouseup`, and `click` event bindings
[✅] Update `log_builder_controller.js` → add `startPressTimer()`, `cancelPressTimer()`, and modify `addSet()` to run on click
[✅] Update `log_builder_controller.js` → ensure `startVoiceInput()` is triggered on long press only



🧠 Switch to Vite (Replace Importmap + Assets)
[✅] Initial Vite setup complete
[✅] Add vite_ruby gem to Gemfile
[✅] Run bundle install
[✅] bundle exec vite install (generates config, folders, entrypoint)

🗂️ Move Controllers → Vite Structure
[✅] log-builder-controller.js → app/frontend/controllers/
[✅] split-selector-controller.js → app/frontend/controllers/
[✅] chart-controller.js → app/frontend/controllers/
[✅] hello-controller.js → app/frontend/controllers/
[✅] index.js → app/frontend/controllers/

⚙️ Stimulus Entrypoint
[✅] Create app/frontend/entrypoints/application.js
[✅] Add Stimulus bootloader

🧼 Remove Importmap-Specific Setup
[✅] Delete app/javascript/application.js
[✅] Remove app/javascript/controllers/* after moving
[✅] Clean config/importmap.rb pins: application, @hotwired/stimulus, controllers/*
[✅] Replace in layouts/application.html.erb


<!-- constants  -->

# Hardcoded user-facing split options (e.g. "3 day split")
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
}

  # Symbol-based workout dictionary per muscle group
  WORKOUTS = {
  entire_body: ["Burpees", "Kettlebell Swings", "Clean and Press", "Snatch"],
  upper_body: ["Pull-Ups", "Push-Ups", "Overhead Press", "Dumbbell Bench Press"],
  lower_body: ["Squats", "Lunges", "Romanian Deadlifts", "Leg Press"],
  push_chest_shoulders_triceps: ["Bench Press", "Overhead Press", "Tricep Dips", "Incline Dumbbell Press"],
  pull_back_biceps: ["Pull-Ups", "Barbell Rows", "Lat Pulldown", "Barbell Curl"],
  legs: ["Barbell Squat", "Leg Press", "Romanian Deadlift", "Walking Lunges"],
  chest_and_triceps: ["Bench Press", "Incline Press", "Cable Flys", "Triceps Pushdown"],
  back_and_biceps: ["Deadlift", "Lat Pulldown", "Barbell Curl", "Seated Row"],
  shoulders: ["Overhead Press", "Lateral Raise", "Rear Delt Fly", "Arnold Press"],
  core: ["Plank", "Russian Twists", "Leg Raises", "Cable Crunch"],
  chest: ["Flat Bench Press", "Incline Dumbbell Press", "Chest Fly Machine", "Push-Ups"],
  back: ["Pull-Ups", "Barbell Rows", "Seated Cable Row", "Lat Pulldown"],
  arms_biceps_and_triceps: ["Barbell Curl", "Hammer Curl", "Tricep Dips", "Skull Crushers"],
  quads_and_calves: ["Leg Press", "Front Squat", "Seated Calf Raise", "Walking Lunges"],
  hamstrings_and_glutes: ["Romanian Deadlifts", "Hip Thrusts", "Glute Bridge", "Cable Kickbacks"],
  biceps: ["Dumbbell Curl", "EZ-Bar Curl", "Concentration Curl", "Preacher Curl"],
  triceps: ["Tricep Rope Pushdown", "Overhead Dumbbell Extension", "Close-Grip Bench Press"],
  quads: ["Front Squat", "Bulgarian Split Squat", "Leg Extension", "Walking Lunges"],
  hamstrings: ["Romanian Deadlifts", "Leg Curl Machine", "Good Mornings"],
  glutes_and_calves: ["Hip Thrusts", "Cable Kickbacks", "Standing Calf Raise", "Donkey Calf Raise"],
  chest_pectorals: ["Flat Bench Press", "Pec Deck Machine", "Cable Crossover", "Incline Dumbbell Press"],
  back_lats_trapezius_rhomboids: ["Deadlift", "Lat Pulldown", "Face Pulls", "T-Bar Row"],
  shoulders_deltoids: ["Overhead Press", "Lateral Raises", "Reverse Fly", "Upright Row"],
  legs_quads_and_hamstrings: ["Barbell Squat", "Leg Press", "Romanian Deadlift", "Walking Lunges"],
  legs_glutes_and_calves: ["Hip Thrusts", "Donkey Calf Raise", "Cable Kickbacks", "Step-Ups"],
  core_abs_and_obliques: ["Bicycle Crunches", "Plank", "Side Plank", "Hanging Leg Raises"],
  forearms_and_grip_strength: ["Farmer’s Walk", "Wrist Curls", "Dead Hangs", "Reverse Curls"],
  neck_and_mobility_stretching: ["Neck Flexion", "Neck Extension", "Foam Rolling", "Yoga Poses"]
  }

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
  }

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
  neck_and_mobility_stretching: "Neck & Mobility/Stretching"
  }
