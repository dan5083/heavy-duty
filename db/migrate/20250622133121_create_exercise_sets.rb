class CreateExerciseSets < ActiveRecord::Migration[8.0]
  def change
    create_table :exercise_sets do |t|
      t.references :workout_log, null: false, foreign_key: true
      t.string :exercise_name, null: false
      t.integer :set_number, null: false
      t.string :set_type, default: 'working'
      t.integer :reps
      t.decimal :weight_kg, precision: 6, scale: 2
      t.string :weight_unit, default: 'kg'
      t.text :notes
      t.timestamps
    end

    add_index :exercise_sets, [:workout_log_id, :exercise_name, :set_number],
              name: 'index_exercise_sets_on_log_exercise_set'
  end
end
