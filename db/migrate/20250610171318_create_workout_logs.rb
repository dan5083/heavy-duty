class CreateWorkoutLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :workout_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :workout, null: false, foreign_key: true
      t.text :details

      t.timestamps
    end
  end
end
