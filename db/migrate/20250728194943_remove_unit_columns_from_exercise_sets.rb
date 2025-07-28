class RemoveUnitColumnsFromExerciseSets < ActiveRecord::Migration[8.0]
  def up
    # Remove the pointless unit columns - we only use kg and meters
    remove_column :exercise_sets, :weight_unit, :string
    remove_column :exercise_sets, :distance_unit, :string

    # Remove any indexes that might reference these columns
    # (There shouldn't be any based on the schema, but safety first)
  end

  def down
    # Add them back if we need to rollback
    add_column :exercise_sets, :weight_unit, :string, default: "kg"
    add_column :exercise_sets, :distance_unit, :string

    # Restore default values for existing records
    ExerciseSet.update_all(weight_unit: "kg")
    # distance_unit stays null - we never used it consistently anyway
  end
end
