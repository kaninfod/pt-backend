class SchedulerMasterImport < AppJob
  queue_as :import

  def perform()
    begin
      logger.info "Things are happening."
      master = Catalog.master
      master.import
      @job_db.update(jobable_id: master.id, jobable_type: "Catalog")
    rescue Exception => e
      @job_db.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job_db.id}. Error: #{e}"
      return
    end

  end

end
