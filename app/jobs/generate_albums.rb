class GenerateAlbums < AppJob
  queue_as :utility

  def perform()

    begin
      Album.generate_year_based_albums
      Album.generate_month_based_albums
      Album.generate_inteval_based_albums
    rescue Exception => e
      @job_db.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job_db.id}. Error: #{e}"
      return
    end

  end
end
