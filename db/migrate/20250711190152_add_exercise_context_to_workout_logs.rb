class AddExerciseContextToWorkoutLogs < ActiveRecord::Migration[8.0]
  def change
    add_column :workout_logs, :exercise_context, :text
  end
end
