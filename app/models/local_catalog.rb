class LocalCatalog < Catalog
  before_destroy :delete_contents

  def import
    #raise "Catalog is not online" unless online
    if self.sync_from_albums.blank?
      LocalCloneInstancesFromCatalogJob.perform_later self.id, self.sync_from_catalog
    else
      self.sync_from_albums.each do |album_id|
        LocalCloneInstancesFromAlbumJob.perform_later self.id, album_id
      end
    end
  end

  def import_photo(photo_id)
    pf = PhotoFilesApi::Api::new

    photo = Photo.find(photo_id)
    instance = photo.instances.where(catalog_id: self.id).first
    photofile = pf.show(photo.org_id)

    dst_path = File.join(self.path, photofile[:path][0], photofile[:path][1], photofile[:path][2])
    dst_file = File.join(self.path, photofile[:path][0], photofile[:path][1], photofile[:path][2], photofile[:path][3])

    if not File.exist?(dst_file)
      file = Tempfile.new("local.jpg")
      begin
        file.binmode
        file.write open(photofile[:url]).read

        src = file.path

        FileUtils.mkdir_p dst_path
        FileUtils.cp src, dst_file

        instance.touch
        instance.update(path: dst_file)
      ensure
        file.close
        file.unlink
      end
    end

  end

  def online
    File.exist?(self.path)
  end

  def delete_contents
    #triggered when entire catalog is deleted
    instances.each do |instance|
      instance.destroy
    end
  end

  def delete_photo(photo_id)
    begin
      #instance = self.instances.where{photo_id.eq(photo_id)}.first
      instance = self.instances.where(photo_id: photo_id).first
      if not instance.nil?
        if File.exist?(instance.path)
          FileUtils.rm(instance.path)
        end
      end
      #instance.destroy
    rescue Exception => e

      logger.debug "#{e}"
    end
  end

  private


end
