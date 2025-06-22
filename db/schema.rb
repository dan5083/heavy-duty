# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_06_22_160240) do
  create_table "exercise_sets", force: :cascade do |t|
    t.integer "workout_log_id", null: false
    t.string "exercise_name", null: false
    t.integer "set_number", null: false
    t.string "set_type", default: "working"
    t.integer "reps"
    t.decimal "weight_kg", precision: 6, scale: 2
    t.string "weight_unit", default: "kg"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workout_log_id", "exercise_name", "set_number"], name: "index_exercise_sets_on_log_exercise_set"
    t.index ["workout_log_id"], name: "index_exercise_sets_on_workout_log_id"
  end

  create_table "split_days", force: :cascade do |t|
    t.integer "split_plan_id", null: false
    t.string "muscle_group"
    t.integer "day_number"
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["split_plan_id"], name: "index_split_days_on_split_plan_id"
  end

  create_table "split_plans", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.integer "split_length"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_custom", default: false, null: false
    t.text "custom_config", default: "{}", null: false
    t.index ["is_custom"], name: "index_split_plans_on_is_custom"
    t.index ["user_id"], name: "index_split_plans_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workout_logs", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "workout_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_benchmark", default: false
    t.index ["user_id"], name: "index_workout_logs_on_user_id"
    t.index ["workout_id", "is_benchmark"], name: "index_workout_logs_on_workout_id_and_is_benchmark"
    t.index ["workout_id"], name: "index_workout_logs_on_workout_id"
  end

  create_table "workouts", force: :cascade do |t|
    t.integer "split_day_id", null: false
    t.string "name"
    t.string "muscle_group"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["split_day_id"], name: "index_workouts_on_split_day_id"
  end

  add_foreign_key "exercise_sets", "workout_logs"
  add_foreign_key "split_days", "split_plans"
  add_foreign_key "split_plans", "users"
  add_foreign_key "workout_logs", "users"
  add_foreign_key "workout_logs", "workouts"
  add_foreign_key "workouts", "split_days"
end
