## ⚠️ Rails 8 + Propshaft CSS Architecture Note

**IMPORTANT**: This app uses Rails 8 with Propshaft (not Sprockets). CSS components are compiled as separate files and must be explicitly included in the layout.

When adding new CSS files in `app/assets/stylesheets/components/` or `app/assets/stylesheets/pages/`, you MUST update the stylesheet_link_tag in `app/views/layouts/application.html.erb`:


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
│   ├── user.rb                          # ✅ has_many :split_plans, :workout_logs (with Devise)
│   ├── split_plan.rb                    # ✅ belongs_to :user, has_many :split_days
│   ├── split_day.rb                     # ✅ belongs_to :split_plan, has_many :workouts
│   ├── workout.rb                       # ✅ belongs_to :split_day, has_many :workout_logs
│   └── workout_log.rb                   # ✅ belongs_to :user, :workout (actual completed session)
|
├── javascript/
│   ├── application.js                   # ✅ Bootstraps Stimulus app with Importmap
│   └── controllers/
│       ├── application.js               # ✅ Stimulus application bootstrap
│       ├── hello_controller.js          # ✅ Default Stimulus controller
│       ├── index.js                     # ✅ Controller index file
│       ├── split_selector_controller.js # ✅ Interactive split plan selection (working)
│       └── log_builder_controller.js    # ✅ Exercise selection for workouts (needs debug)
|
├── controllers/
│   ├── users_controller.rb              # ✅ user logs + muscle readiness
│   ├── split_plans_controller.rb        # ✅ split selection, create, show, recovery setup
│   ├── split_days_controller.rb         # ✅ per-day muscle config, exercise assignment
│   ├── dashboard_controller.rb          # ✅ readiness + recovery schedule
│   ├── workouts_controller.rb           # ✅ add/edit workouts to days, show exercise detail
│   ├── workout_logs_controller.rb       # ✅ log sets/reps/RPE (scoped to workout)
│   └── training_archive_controller.rb   # ✅ global archive view (by muscle/date)
│
├── helpers/
│   ├── application_helper.rb            # ✅ global view helpers
│   ├── recovery_helper.rb               # ✅ readiness_label, current_split_muscles, log_path_for_muscle
│   └── workouts_helper.rb               # ✅ render_benchmark_details, parse_workout_details
│
├── views/
│   ├── layouts/
│   │   └── application.html.erb         # ✅ Fixed layout with Importmap (no Vite)
│   │
│   ├── split_plans/
│   │   ├── index.html.erb               # ✅ list of plans
│   │   ├── new.html.erb                 # ✅ split selector with Stimulus controller
│   │   ├── initialize_recovery.html.erb # ✅ recovery seeding form
│   │   └── show.html.erb                # ✅ split viewer (log status, recovery cards)
│   │
│   ├── split_days/
│   │   └── edit.html.erb                # ✅ toggle muscle config or workouts
│   │
│   ├── workouts/
│   │   ├── new.html.erb                 # ✅ assign exercise
│   │   ├── show.html.erb                # ✅ exercise detail view (RPE, history)
│   │   └── _form.html.erb               # ✅ shared workout form
│   │
│   ├── workout_logs/
│   │   └── new.html.erb                 # ✅ log performance with Stimulus (needs debug)
│   │
│   ├── dashboard/
│   │   ├── _muscle_countdown.html.erb   # ✅ recovery tile partial
│   │   └── index.html.erb               # ✅ "what's trainable" view
│   │
│   ├── training_archive/
│   │   └── index.html.erb               # ✅ full historical log (by muscle/date)
│   │
│   └── shared/
│       ├── _benchmark_panel.html.erb    # ✅ displays workout benchmark data
│       ├── _workout_log_row.html.erb    # ✅ table row partial for logs
│       ├── _navbar.html.erb             # ✅ main navigation with auth
│       └── _workout_card.html.erb       # ✅ card-style layout for workouts
|
├── logic/
│   ├── recovery_tracker.rb              # ✅ recovery countdown logic, forecast methods
│   └── muscle_recovery_status.rb        # ✅ per-muscle readiness engine
|
├── presenters/
│   ├── split_day_presenter.rb           # ✅ formats SplitDay layout
│   ├── workout_presenter.rb             # ✅ formats workout name, reps, logs
│   └── workout_log_presenter.rb         # ✅ formats workout logs
│
config/
├── routes.rb                            # ✅ Nested RESTful routes with custom actions
├── importmap.rb                         # ✅ JavaScript module management (no build step)
└── initializers/
    └── simple_form.rb                   # ✅ Simple Form configuration
│
lib/
└── app_constants.rb                     # ✅ SPLITS, WORKOUTS, LABELS, TRAINING_CYCLE
│
db/
├── migrate/
│   ├── *_create_users.rb                # ✅ Basic user table
│   ├── *_add_devise_to_users.rb         # ✅ Devise authentication fields
│   ├── *_create_split_plans.rb          # ✅ User's training plans
│   ├── *_create_split_days.rb           # ✅ Days within plans
│   ├── *_create_workouts.rb             # ✅ Exercises assigned to days
│   └── *_create_workout_logs.rb         # ✅ Completed workout sessions
├── schema.rb                            # ✅ Current database structure
└── seeds.rb                             # ✅ Demo user with 6-day split + logs

# STATUS SUMMARY
✅ WORKING: Authentication, routing, dashboard, recovery tracking, split creation
✅ WORKING: Exercise selection UI, benchmark display, navigation
🔧 DEBUG NEEDED: Log-builder Stimulus controller (exercise selection → JSON)
🎯 NEXT: Fix workout logging data capture, verify form submission
