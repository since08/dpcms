ActiveAdmin.register ProductWxBill, namespace: :shop do
  menu priority: 3, parent: '订单管理'
  config.batch_actions = false
  config.clear_action_items!

  index do
    id_column
    column :用户 do |bill|
      bill.product_order.user.nick_name
    end
    column('订单编号') { |bill| bill.product_order.order_number }
    column :open_id, sortable: false
    column :total_fee do |bill|
      bill.total_fee.to_i / 100
    end
    column :fee_type, sortable: false
    column :time_end
    column :trade_type, sortable: false
    column :result_code, sortable: false
    column :return_code, sortable: false
    column :transaction_id
  end
end
