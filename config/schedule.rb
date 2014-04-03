# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
require File.expand_path('../environment', __FILE__)

set :environment, Rails.env

set :output, {
  :error    => "#{path}/log/cron_error.log",
  :standard => "#{path}/log/cron.log"
}

require File.expand_path('../environment', __FILE__)

every '* * * * *' do
  runner "Newsletter.deliver"
end

every :sunday, at: '12pm' do
  runner "Invoice.generate"
end

ScheduleJob.all.each do |schedule_job|
  every schedule_job.week_day, :at => schedule_job.at do
    runner "#{schedule_job.model}.#{schedule_job.action}"
  end
end
