class ChangeParentId < ActiveRecord::Migration[5.0]
  def change
    rename_column :jobs, :parent_id, :jobable_id
    rename_column :jobs, :parent_model, :jobable_type
  end
end
