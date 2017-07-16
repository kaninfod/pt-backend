class AddCityModel < ActiveRecord::Migration[5.1]
  def change
    create_table :cities do |t|
      t.string :name
    end

    add_reference :locations, :city, foreign_key: true

  end
end
