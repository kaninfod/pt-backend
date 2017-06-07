class MasterCatalog < Catalog
  include RailsSettings::Extend
  validates :type, uniqueness: true

  def import
    return if self.settings.updating == true

    begin
      job = []
      import_path = Rails.configuration.phototank["incoming"]
      Rails.logger.info "Starting master import"
      # self.watch_path.each do |import_path|
      response = MasterImportSpawn.perform_later import_path, photo_id = nil, import_mode=self.import_mode
      job.push(response)
      # end
      return job
    rescue Exception => e
      return e
    end
  end

  def online
    true
  end

  def delete_photo(photo_id)
    begin
      photo = self.photos.find(photo_id)

      Photofile.find(photo.tm_id).destroy
      Photofile.find(photo.md_id).destroy
      Photofile.find(photo.lg_id).destroy
      Photofile.find(photo.org_id).destroy

    rescue Exception => e
      Rails.logger.debug "Error: #{e}"
    end
  end

  def self.create_master()
    if MasterCatalog.count == 0
      c = Catalog.new
      c.type = "MasterCatalog"
      c.name = "Master Catalog"
      c.default = true
      c.path = ""
      c.watch_path = []
      c.save
      Rails.cache.delete("master_catalog")
      return c.id
    end
  end

end
