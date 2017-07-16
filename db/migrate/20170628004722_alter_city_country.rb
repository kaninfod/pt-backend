class AlterCityCountry < ActiveRecord::Migration[5.1]
  def change
    remove_column :locations, :city, :string

    rename_column :countries, :country, :name
  end
end
