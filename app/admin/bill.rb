# rubocop:disable Metrics/BlockLength
ActiveAdmin.register Bill do
  menu priority: 4, parent: '订单管理'
  config.batch_actions = false
  config.clear_action_items!

  scope :all
  scope :trade_success, &:success_bills
  scope :trade_fail, &:fail_bills

  filter :order_number
  filter :amount
  filter :pay_time
  filter :trade_number

  index do
    id_column
    column :ticket_name do |bill|
      bill.order.ticket.title if bill.order.present?
    end
    column :用户 do |bill|
      bill.order.user_extra&.real_name if bill.order.present? && bill.order.user_extra.present?
    end
    column :order_number
    column :amount
    column :pay_time
    column :trade_status
    column :trade_msg
    column :trade_number
  end

  sidebar :'交易统计', only: :index do
    success_number = Bill.where(trade_status: 0).count
    failed_number = Bill.where.not(trade_status: 0).count
    success_count = Bill.where(trade_status: 0).sum('amount')
    ul do
      li "交易成功数：#{success_number}"
      li "总成交金额：#{success_count}"
      li "失败订单数：#{failed_number}"
    end
  end
end
