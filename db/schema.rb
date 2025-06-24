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

ActiveRecord::Schema[8.0].define(version: 2025_06_24_174343) do
  create_table "audit_logs", force: :cascade do |t|
    t.integer "performer_id", null: false
    t.integer "subject_id", null: false
    t.string "action", null: false
    t.string "resource_type"
    t.integer "resource_id"
    t.text "metadata"
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.index ["action", "created_at"], name: "index_audit_logs_on_action_and_created_at"
    t.index ["created_at"], name: "index_audit_logs_on_created_at"
    t.index ["performer_id", "created_at"], name: "index_audit_logs_on_performer_id_and_created_at"
    t.index ["performer_id"], name: "index_audit_logs_on_performer_id"
    t.index ["resource_type", "resource_id"], name: "index_audit_logs_on_resource_type_and_resource_id"
    t.index ["subject_id", "created_at"], name: "index_audit_logs_on_subject_id_and_created_at"
    t.index ["subject_id"], name: "index_audit_logs_on_subject_id"
  end

  create_table "client_assignments", force: :cascade do |t|
    t.integer "personal_trainer_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["personal_trainer_id"], name: "index_client_assignments_on_personal_trainer_id"
    t.index ["user_id"], name: "index_client_assignments_on_user_id"
  end

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

  create_table "personal_trainers", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_personal_trainers_on_user_id"
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

  add_foreign_key "audit_logs", "users", column: "performer_id"
  add_foreign_key "audit_logs", "users", column: "subject_id"
  add_foreign_key "client_assignments", "personal_trainers"
  add_foreign_key "client_assignments", "users"
  add_foreign_key "exercise_sets", "workout_logs"
  add_foreign_key "personal_trainers", "users"
  add_foreign_key "split_days", "split_plans"
  add_foreign_key "split_plans", "users"
  add_foreign_key "workout_logs", "users"
  add_foreign_key "workout_logs", "workouts"
  add_foreign_key "workouts", "split_days"
end
