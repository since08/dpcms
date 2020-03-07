require 'rails_helper'

RSpec.describe UserExtra, type: :model do
  describe 'notify_certification 触发规则' do
    it '当实名审核通过或不通过时，应触发通知' do
      user_extra = FactoryGirl.create(:user_extra)
      user_extra.failed!
      user_extra.passed!
      notifications = user_extra.user.notifications
      expect(notifications.size).to eq(2)
      notifications.each do |notification|
        expect(notification.notify_type).to eq('certification')
        expect(notification.source_id).to eq(user_extra.id)
        expect(notification.source_type).to eq('UserExtra')
      end
    end

    it '当状态改变为pending 或 init 不触发通知消息' do
      user_extra = FactoryGirl.create(:user_extra)
      user_extra.pending!
      user_extra.init!
      notifications = user_extra.user.notifications
      expect(notifications.size).to eq(0)
    end

  end
end
