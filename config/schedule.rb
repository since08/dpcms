# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, './log/cron_log.log'
# set :environment, 'development'

every '10 * * * *' do
  rake 'batch_order:cancel_unpaid_one_day_ago'
end

every :day, at: '2:30am' do
  rake 'batch_order:complete_delivered_15_days'
end

every '20 * * * *' do
  rake 'batch_order:cancel_product_unpaid_order_half_an_hour'
end

every :day, at: '3:30am' do
  rake 'batch_order:product_order_complete_delivered_15_days'
end

every 10.minutes do
  rake 'batch_order:topic_increase_view_number'
end
