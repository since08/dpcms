namespace :batch_order do
  desc '将24小时前创建并且未支付的订单取消'
  task cancel_unpaid_one_day_ago: :environment do
    Rails.application.eager_load!
    puts 'cancel_unpaid_one_day_ago start'
    orders = PurchaseOrder.unpaid_one_day_ago
    puts "cancel_unpaid_one_day_ago order sum: #{orders.size}"
    orders.each do |order|
      Services::Orders::CancelOrderService.call(order)
    end
    puts 'cancel_unpaid_one_day_ago end'
  end

  desc '将已发货15天，但未确认收货的订单修改为 已完成'
  task complete_delivered_15_days: :environment do
    Rails.application.eager_load!
    puts 'complete_delivered_15_days start'
    orders = PurchaseOrder.delivered_15_days
    orders.each(&:completed!)
    puts 'complete_delivered_15_days end'
  end

  desc '将商品订单15分钟未付款的订单，自动取消'
  task cancel_product_unpaid_order_half_an_hour: :environment do
    Rails.application.eager_load!
    puts 'cancel_product_unpaid_order_half_an_hour start'
    orders = ProductOrder.unpaid_half_an_hour
    orders.map(&:cancel_order)
    puts 'cancel_product_unpaid_order_half_an_hour end'
  end

  desc '将已发货15天，但未确认收货的商品订单修改为 已完成'
  task product_order_complete_delivered_15_days: :environment do
    Rails.application.eager_load!
    puts 'product_order_complete_delivered_15_days start'
    orders = ProductOrder.delivered_15_days
    orders.each(&:completed!)
    puts 'product_order_complete_delivered_15_days end'
  end

  desc '每隔10分钟检查一次，是否有话题的浏览量需要增值'
  task topic_increase_view_number: :environment do
    Rails.application.eager_load!
    puts 'topic_increase_view_number start'
    Services::AutoIncreaseCount.call
    puts 'topic_increase_view_number end'
  end
end