class DropboxCloneInstancesFrom < AppJob
  queue_as :import

  def perform(action, options)

    begin
      case action
      when "import_files"
        catalog = Catalog.find(options["catalog_id"])
        catalog.copy_files(options["photo_id"])
      when "clone_instances_from_catalog"
        catalog = Catalog.find(options["catalog_id"])
        catalog.clone_instances_from_catalog
        catalog.import_files
      end
    rescue Exception => e
      @job_db.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job_db.id}. Error: #{e}"
      return
    end
  end


end
