# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#

every 1.day, at: '8:00 am' do
  rake "notification:send_message_notification_email"
end

# Learn more: http://github.com/javan/whenever
