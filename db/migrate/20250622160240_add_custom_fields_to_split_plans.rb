class AddCustomFieldsToSplitPlans < ActiveRecord::Migration[8.0]
  def change
    add_column :split_plans, :is_custom, :boolean, default: false, null: false
    add_column :split_plans, :custom_config, :text, default: '{}', null: false

    # Add index for better performance when querying custom splits
    add_index :split_plans, :is_custom
  end
end
