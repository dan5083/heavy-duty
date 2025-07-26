class AddVariationFieldsToWorkoutLogs < ActiveRecord::Migration[8.0]
  def change
    add_column :workout_logs, :benchmark_variation, :string
    add_column :workout_logs, :is_default_variation, :boolean, default: false

    # Migrate existing benchmark data
    reversible do |dir|
      dir.up do
        # Set all existing benchmarks to variation A and mark as default
        WorkoutLog.where(is_benchmark: true).update_all(
          benchmark_variation: 'A',
          is_default_variation: true
        )
      end
    end
  end
end
