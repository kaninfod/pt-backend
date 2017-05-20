require 'resque/tasks'
require 'resque-loner'
require 'resque/scheduler/tasks'

task 'resque:setup' => :environment


def get_pgid(file)
  pgid = true
  if File.file?(file)
    fpid = File.read(file).to_i
    pgid = `ps -o pgid --no-headers --pid #{fpid}`.strip!
    if pgid
      puts "Process group ID found: #{pgid}"
      pgid = pgid.to_i
    end
  end
  pgid
end

# Start a worker with proper env vars and output redirection
def run_worker(queue, count = 1)
  puts "Starting #{count} worker(s) with QUEUE: #{queue}"
# one pid for first worker
  parent_pid_file = 'tmp/resque.pid'
# getting process group ID
  ops = {:pgroup => get_pgid(parent_pid_file), :err => [(Rails.root + 'log/resque_err').to_s, 'a'],
                          :out => [(Rails.root + 'log/resque_stdout').to_s, 'a']}
  env_vars = {'QUEUES' => queue.to_s,
              # 'BACKGROUND' => 'yes',
              'TERM_CHILD' => '1',
              # 'VVERBOSE' => '1',
              'REDISTOGO_URL' => 'redis://redis:6379/'}
# adding pid file if there is no yet
  env_vars['PIDFILE'] = parent_pid_file if !File.file?(parent_pid_file)
  count.times {
    ## Using Kernel.spawn and Process.detach because regular system() call would
    ## cause the processes to quit when capistrano finishes
    pid = spawn(env_vars, 'bundle exec rake resque:work', ops)
    Process.detach(pid)
  }
end

# Start a worker with proper env vars and output redirection
def run_scheduler(queue, count = 1)
  puts "Starting #{count} scheduler(s) with QUEUE: #{queue}"

  parent_pid_file = 'tmp/resque_scheduler.pid'

  ops = {:pgroup => get_pgid(parent_pid_file), :err => [(Rails.root + 'log/resque_scheduler_err').to_s, 'a'],
                          :out => [(Rails.root + 'log/resque_scheduler_stdout').to_s, 'a']}
  env_vars = {'QUEUES' => queue.to_s,
              # 'BACKGROUND' => 'yes',
              'TERM_CHILD' => '1',
              'REDISTOGO_URL' => 'redis://redis:6379/'}
  env_vars['PIDFILE'] = parent_pid_file if !File.file?(parent_pid_file)
  count.times {
    ## Using Kernel.spawn and Process.detach because regular system() call would
    ## cause the processes to quit when capistrano finishes
    pid = spawn(env_vars, 'bundle exec rake resque:scheduler', ops)
    Process.detach(pid)
  }
end

namespace :resque do

  task :setup => :environment

  desc "Restart running workers"
  task :restart_workers => :environment do
    Rake::Task['resque:stop_workers'].invoke
    Rake::Task['resque:start_workers'].invoke
  end

  task :restart_schedulers => :environment do
    Rake::Task['resque:stop_schedulers'].invoke
    Rake::Task['resque:start_schedulers'].invoke
  end

  desc "Quit running workers"
  task :stop_workers => :environment do
    fpid = File.read('tmp/resque.pid')
    File.delete('tmp/resque.pid')
# getting process group ID
    pgid = `ps -o pgid --no-headers --pid #{fpid}`.strip!
# killing all workers created by this app
    syscmd = "kill -QUIT -\"#{pgid}\""
    puts "Running syscmd: #{syscmd}"
    begin
      system(syscmd)
    rescue => e
      puts "Error: #{e}"
    end
  end

  desc "Quit running schedulers"
  task :stop_schedulers => :environment do
    fpid = File.read('tmp/resque_scheduler.pid')
    File.delete('tmp/resque_scheduler.pid')
    pgid = `ps -o pgid --no-headers --pid #{fpid}`.strip!
    syscmd = "kill -QUIT -\"#{pgid}\""
    puts "Running syscmd: #{syscmd}"
    begin
      system(syscmd)
    rescue => e
      puts "Error: #{e}"
    end
  end

  desc "Start workers"
  task :start_workers => :environment do
    run_worker("utility")
    # there we need timeout because pid file need to be created
    sleep(10)
    run_worker("import")
  end

  desc "Start schedulers"
  task :start_schedulers => :environment do
    # run_scheduler("drafts_checker")
    # sleep(10)
    # run_scheduler("drafts_checker2")
  end

  task :setup_schedule => :setup do
    require 'resque-scheduler'

    # If you want to be able to dynamically change the schedule,
    # uncomment this line.  A dynamic schedule can be updated via the
    # Resque::Scheduler.set_schedule (and remove_schedule) methods.
    # When dynamic is set to true, the scheduler process looks for
    # schedule changes and applies them on the fly.
    # Note: This feature is only available in >=2.0.0.
    # Resque::Scheduler.dynamic = true

    # The schedule doesn't need to be stored in a YAML, it just needs to
    # be a hash.  YAML is usually the easiest.
    Resque.schedule = YAML.load_file('config/resque_schedule.yml')

    # If your schedule already has +queue+ set for each job, you don't
    # need to require your jobs.  This can be an advantage since it's
    # less code that resque-scheduler needs to know about. But in a small
    # project, it's usually easier to just include you job classes here.
    # So, something like this:
    # require 'jobs'
  end

  task :scheduler => :setup_schedule
end
