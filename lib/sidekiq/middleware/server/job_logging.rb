module Sidekiq::Middleware::Server
  class JobLogging
    def call(worker, item, queue)
      klass = item['class']
      args = item['args']
      Rails.logger.info("itemilemi: #{item}")
      Rails.logger.info("hinge Performing #{klass} with arguments: #{args}")
      Rails.logger.info("Saving job to database")
      @job_db = Job.create(
        job_type:   'job.class.name',
        arguments:  'job.arguments',
        queue:      'job.queue_name',
        status:     1 #started
      )
      yield
    end
  end
end
