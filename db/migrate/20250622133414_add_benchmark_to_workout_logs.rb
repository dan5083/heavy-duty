class AddBenchmarkToWorkoutLogs < ActiveRecord::Migration[8.0]
  def change
    add_column :workout_logs, :is_benchmark, :boolean, default: false
    add_index :workout_logs, [:workout_id, :is_benchmark]
  end
end
