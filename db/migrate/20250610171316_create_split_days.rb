class CreateSplitDays < ActiveRecord::Migration[8.0]
  def change
    create_table :split_days do |t|
      t.references :split_plan, null: false, foreign_key: true
      t.string :muscle_group
      t.integer :day_number
      t.string :label

      t.timestamps
    end
  end
end
