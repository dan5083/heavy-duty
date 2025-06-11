class CreateWorkouts < ActiveRecord::Migration[8.0]
  def change
    create_table :workouts do |t|
      t.references :split_day, null: false, foreign_key: true
      t.string :name
      t.string :muscle_group
      t.text :details

      t.timestamps
    end
  end
end
