class AddCardioFieldsToExerciseSets < ActiveRecord::Migration[8.0]
  def change
    add_column :exercise_sets, :duration_seconds, :integer
    add_column :exercise_sets, :distance_value, :decimal, precision: 8, scale: 2
    add_column :exercise_sets, :distance_unit, :string
    add_column :exercise_sets, :intensity, :string

    add_index :exercise_sets, :duration_seconds
    add_index :exercise_sets, [:distance_value, :distance_unit]
  end
end
