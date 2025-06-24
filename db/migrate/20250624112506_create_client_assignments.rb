class CreateClientAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :client_assignments do |t|
      t.references :personal_trainer, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
