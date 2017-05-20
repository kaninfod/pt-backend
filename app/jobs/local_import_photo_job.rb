class LocalImportPhotoJob < AppJob
  include Resque::Plugins::UniqueJob
  queue_as :import

  def perform(catalog_id, photo_id)
    begin
      Catalog.find(catalog_id).import_photo(photo_id)
      @job_db.update(jobable_id: catalog_id, jobable_type: "Photo")
    rescue Exception => e
      @job_db.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job_db.id}. Error: #{e}"
      return
    end
  end
end
