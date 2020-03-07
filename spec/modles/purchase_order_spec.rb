require 'rails_helper'

RSpec.describe PurchaseOrder, type: :model do
  describe 'notify_order 触发规则' do
    it '当创建订单时应不触发通知' do
      order = FactoryGirl.create(:purchase_order)
      notifications = order.user.notifications
      expect(notifications.size).to eq(0)
    end

    it '当订单状态发生改变时应触发通知' do
      order = FactoryGirl.create(:purchase_order)
      order.paid!
      order.completed!
      notifications = order.user.notifications
      expect(notifications.size).to eq(2)
      notifications.each do |notification|
        expect(notification.notify_type).to eq('order')
        expect(notification.source_id).to eq(order.id)
        expect(notification.source_type).to eq('PurchaseOrder')
      end
    end

    it '当订单取消时不触发通知' do
      order = FactoryGirl.create(:purchase_order)
      order.canceled!
      notifications = order.user.notifications
      expect(notifications.size).to eq(1)
    end

  end
end
