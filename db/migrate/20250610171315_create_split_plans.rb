class CreateSplitPlans < ActiveRecord::Migration[8.0]
  def change
    create_table :split_plans do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.integer :split_length

      t.timestamps
    end
  end
end
