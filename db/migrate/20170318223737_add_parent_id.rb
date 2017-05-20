class AddParentId < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :parent_id, :integer
    add_column :jobs, :parent_model, :string
  end
end
