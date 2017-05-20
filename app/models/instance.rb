class Instance < ActiveRecord::Base
  belongs_to :catalog
  belongs_to :photo
  before_destroy :delete_photo

  def delete_photo
    catalog = Catalog.find self.catalog_id
    catalog.delete_photo(self.photo_id)
  end

end
