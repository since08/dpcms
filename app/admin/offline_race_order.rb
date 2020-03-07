ActiveAdmin.register OfflineRaceOrder do
  menu priority: 4, parent: '订单管理'
  config.batch_actions = false
  permit_params :invite_code_id, :mobile, :email, :name, :ticket, :price
  actions :all, except: [:show]

  filter :name
  filter :mobile
  filter :email
  filter :ticket
  filter :created_at

  index do
    render 'index', context: self
  end
end
