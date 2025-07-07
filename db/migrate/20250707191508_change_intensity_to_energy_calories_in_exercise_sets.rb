class ChangeIntensityToEnergyCaloriesInExerciseSets < ActiveRecord::Migration[8.0]
  def change
    remove_column :exercise_sets, :intensity, :string
    add_column :exercise_sets, :energy_calories, :integer
    add_index :exercise_sets, :energy_calories
  end
end
