# rubocop:disable Metrics/BlockLength
ActiveAdmin.register WxBill do
  menu priority: 4, parent: '订单管理'
  config.batch_actions = false
  config.clear_action_items!

  scope :all
  scope :trade_success, &:success_bills
  scope :trade_fail, &:fail_bills

  filter :bank_type
  filter :total_fee
  filter :fee_type
  filter :out_trade_no
  filter :trade_type
  filter :time_end
  filter :transaction_id

  index do
    id_column
    column :ticket_name do |bill|
      bill.order.ticket.title if bill.order.present?
    end
    column :用户 do |bill|
      bill.order.user_extra&.real_name if bill.order.present? && bill.order.user_extra.present?
    end
    column :out_trade_no
    column :open_id, sortable: false
    column :total_fee do |bill|
      bill.total_fee.to_f / 100
    end
    column :fee_type, sortable: false
    column :time_end
    column :trade_type, sortable: false
    column :result_code, sortable: false
    column :return_code, sortable: false
    column :transaction_id
  end

  sidebar :'交易统计', only: :index do
    success_number = WxBill.success_bills.count
    success_count = WxBill.success_bills.sum('total_fee') / 100
    ul do
      li "交易成功数：#{success_number}"
      li "总成交金额：#{success_count}"
    end
  end
end
