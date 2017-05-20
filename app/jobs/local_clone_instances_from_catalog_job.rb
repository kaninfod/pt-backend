class LocalCloneInstancesFromCatalogJob < AppJob
  include Resque::Plugins::UniqueJob
  queue_as :import

  def perform(to_catalog_id, from_catalog_id)

    begin

      Instance.where(catalog_id: from_catalog_id).each do |instance|
        if not Instance.exists? photo_id:instance.photo_id, catalog_id:to_catalog_id
          new_instance = Instance.create(photo_id:instance.photo_id, catalog_id:to_catalog_id)
        end
      end
      LocalImportSpawn.perform_later to_catalog_id
    rescue Exception => e
      @job_db.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job_db.id}. Error: #{e}"
      return
    end

  end
end
