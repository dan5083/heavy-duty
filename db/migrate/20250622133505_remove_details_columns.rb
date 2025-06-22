class RemoveDetailsColumns < ActiveRecord::Migration[8.0]
  def change
    remove_column :workout_logs, :details, :text
    remove_column :workouts, :details, :text
  end
end
