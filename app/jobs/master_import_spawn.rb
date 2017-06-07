class MasterImportSpawn < AppJob
  include Resque::Plugins::UniqueJob
  queue_as :import

  def perform(path, photo_id= nil, import_mode=true)
    begin
      require 'find'
      dir_blacklist = ['existing']
      ext_whitelist = ['.jpg', '.JPG']
      UtilSetSetting.perform_later 'MasterCatalog', Catalog.master.id, 'updating', true
      Rails.logger.info "Spawning - rails"
      Resque.logger.info "Spawning -resque"
      Find.find(path) do |path|
        name = File.basename(path)
        if FileTest.directory?(path)
          if dir_blacklist.include? name
            Find.prune
          else
            next
          end
        else
          ext = File.extname(name)
          if ext_whitelist.include? ext
            MasterImportPhoto.perform_later path, photo_id, import_mode
          end
        end
      end

      UtilSetSetting.perform_later 'MasterCatalog', Catalog.master.id, 'updating', false
      @job_db.update(jobable_id: Catalog.master.id, jobable_type: "Catalog")
    rescue Exception => e
      @job_db.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job_db.id}. Error: #{e}"
      return
    end

  end




end
