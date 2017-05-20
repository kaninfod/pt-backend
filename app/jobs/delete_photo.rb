class DeletePhoto < AppJob
  queue_as :utility

  def perform(photo_id)
    begin
      Photo.find(photo_id).destroy
      @job_db.update(jobable_id: photo_id, jobable_type: "Photo")
    rescue Exception => e
      @job_db.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job_db.id}. Error: #{e}"
      return
    end

  end
end
