class AppJob < ActiveJob::Base


  before_perform do |job|
    @job_db = Job.create(
      job_type:   job.class.name,
      arguments:  job.arguments,
      queue:      job.queue_name,
      status:     1 #started
    )
  end

  after_perform do |job|
    if @job_db.status != 2
      status = 0 #no errors
    else
      status = 2 #something went wrong
    end
    @job_db.update(
      status: status ,
      completed_at: Time.now
    )
  end


end
