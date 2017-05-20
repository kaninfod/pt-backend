class PhotoMoveByDate < AppJob
  include Resque::Plugins::UniqueJob
  queue_as :utility

  def perform(photo_id)
    #TODO Change this to use Photofiles
    begin

      photo = Photo.find(photo_id)
      _new_file_thumb_path = File.join('phototank', 'thumbs', get_date_path(photo.date_taken))
      _new_path = File.join('phototank', 'originals', get_date_path(photo.date_taken))
      _filename = photo.filename + photo.file_extension

      move_with_path photo.original_filename, File.join(Catalog.master.path, _new_path, File.basename(photo.original_filename))
      move_with_path photo.large_filename, File.join(Catalog.master.path, _new_file_thumb_path,  File.basename(photo.large_filename))
      move_with_path photo.medium_filename, File.join(Catalog.master.path, _new_file_thumb_path, File.basename(photo.medium_filename))
      move_with_path photo.small_filename, File.join(Catalog.master.path, _new_file_thumb_path, File.basename(photo.small_filename))

      photo.path = _new_path
      photo.file_thumb_path = _new_file_thumb_path
      photo.save
      @job_db.update(jobable_id: photo.id, jobable_type: "Photo")
    rescue Exception => e
      @job_db.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job_db.id}. Error: #{e}"
      return
    end

  end

  private
    def self.get_date_path(date)
      date_path = File.join(
        date.strftime("%Y"),
        date.strftime("%m"),
        date.strftime("%d")
      )
      return date_path
    end
    def self.move_with_path(src, dst)
      FileUtils.mkdir_p(File.dirname(dst))
      File.rename(src, dst)
    end

end
