class UtilSetSetting < AppJob
  queue_as :import

  def perform(klass, id, setting, value)

    begin
      cls = Object.const_get(klass)
      obj = cls.find(id)
      obj.settings[setting.to_sym] = value
    rescue Exception => e
      @job_db.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job_db.id}. Error: #{e}"
      return
    end

  end

end
