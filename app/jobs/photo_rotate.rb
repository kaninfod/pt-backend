
class PhotoRotate < AppJob
  queue_as :utility

  def perform(photo_id, degrees)
    Sidekiq.logger.info "rotating image - photo_id: #{photo_id}...s"
    begin
      photo = Photo.find(photo_id)
      new_phash = 0
      photo.get_photofiles_hash.each do |key, id|
        Photofile.find(id).rotate(degrees)
        if key == :original
          new_phash = Photofile.find(id).get_phash
        end
      end

      #set and save phash
      photo.update(phash:new_phash, status: 0)
      @job_db.update(jobable_id: photo.id, jobable_type: "Photo")
    rescue Exception => e
      @job_db.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job_db.id}. Error: #{e}"
      return
    end

  end
end
