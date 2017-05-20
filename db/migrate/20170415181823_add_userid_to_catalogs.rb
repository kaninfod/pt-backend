class AddUseridToCatalogs < ActiveRecord::Migration[5.0]
  def change
    add_column :catalogs, :user_id, :integer
  end
end
