class CreateAuditLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :audit_logs do |t|
      t.references :performer, null: false, foreign_key: { to_table: :users }
      t.references :subject, null: false, foreign_key: { to_table: :users }
      t.string :action, null: false
      t.string :resource_type
      t.integer :resource_id
      t.text :metadata
      t.string :ip_address
      t.string :user_agent

      t.datetime :created_at, null: false
    end

    # Indexes for common queries
    add_index :audit_logs, [:performer_id, :created_at]
    add_index :audit_logs, [:subject_id, :created_at]
    add_index :audit_logs, [:action, :created_at]
    add_index :audit_logs, [:resource_type, :resource_id]
    add_index :audit_logs, :created_at
  end
end
