class CreatePersonalTrainers < ActiveRecord::Migration[8.0]
  def change
    create_table :personal_trainers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.text :bio

      t.timestamps
    end
  end
end
