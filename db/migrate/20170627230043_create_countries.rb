class CreateCountries < ActiveRecord::Migration[5.1]
  def change



    create_table :countries do |t|
      t.string :country
    end

    add_reference :locations, :country, foreign_key: true


  end
end
