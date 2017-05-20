class ResqueJob

  def self.after_perform(*args)
    if @job.status != 2
      status = 0
    else
      status = 2
    end
    @job.update(
      status: status ,
      completed_at: Time.now
    )
  end

  def self.before_perform(*args)
    @job = Job.create(
      job_type:   self.name,
      arguments:  args,
      queue:      @queue,
      status:     1 #started
    )
  end

end
