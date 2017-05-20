require 'resque/server'
require 'resque/scheduler/server'
require 'active_scheduler'

config = YAML.load(File.open("#{Rails.root}/config/resque.yml"))[Rails.env]
Resque.redis = Redis.new(host: config['host'], port: config['port'], db: config['db'])

yaml_schedule    = YAML.load_file("#{Rails.root}/config/resque_scheduler.yml") || {}
wrapped_schedule = ActiveScheduler::ResqueWrapper.wrap yaml_schedule
Resque.schedule  = wrapped_schedule



# SchedulerMasterImport.perform_later
# Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_scheduler.yml")
logfile = File.open(File.join(Rails.root, 'log', 'resque.log'), 'a')
logfile.sync = true
Resque.logger = ActiveSupport::Logger.new(logfile)
Resque.logger.level = Logger::DEBUG
Resque.logger.info "logger initialized"
