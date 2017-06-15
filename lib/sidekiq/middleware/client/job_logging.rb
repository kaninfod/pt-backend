# class phototank::JobLogging
#   def call(worker, msg, queue)
#
#     Rails.logger.info("itemilemi - m: #{msg}")
#     Rails.logger.info("itemilemi - w: #{worker}")
#     Rails.logger.info("itemilemi - q: #{queueu}")
#     Rails.logger.info("Saving job to database")
#     @job_db = Job.create(
#       job_type:   'job.class.name',
#       arguments:  'job.arguments',
#       queue:      'job.queue_name',
#       status:     1 #started
#     )
#     yield
#   end
# end
