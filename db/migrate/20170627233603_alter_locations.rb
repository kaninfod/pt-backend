class AlterLocations < ActiveRecord::Migration[5.1]
  def change

    remove_column :locations, :country, :string

  end
end
