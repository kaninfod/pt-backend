class AddMappingTableAlbumsPhotos < ActiveRecord::Migration[5.1]
  def change
    create_table :albums_photos, id: false do |t|
      t.belongs_to :album, index: true
      t.belongs_to :photo, index: true  
    end
  end
end
