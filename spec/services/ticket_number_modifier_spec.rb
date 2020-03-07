require 'rails_helper'

RSpec.describe Services::TicketNumberModifier do
  let!(:race) { FactoryGirl.create(:race) }
  let!(:ticket) { FactoryGirl.create(:ticket, race: race, status: 'selling') }
  let!(:ticket_info) { FactoryGirl.create(:ticket_info, ticket: ticket) }

  context '当ticket_info lock_version正确时' do
    it '新增电子票成功' do
      e_ticket_number = ticket_info.e_ticket_number
      result = Services::TicketNumberModifier.call(ticket, e_ticket_increment: 1)
      expect(result.code).to eq(0)
      expect(e_ticket_number + 1).to eq(ticket_info.reload.e_ticket_number)
    end

    it '减少电子票成功' do
      e_ticket_number = ticket_info.e_ticket_number
      result = Services::TicketNumberModifier.call(ticket, e_ticket_decrement: 1)
      expect(result.code).to eq(0)
      expect(e_ticket_number - 1).to eq(ticket_info.reload.e_ticket_number)
    end

    it '新增实体票成功' do
      entity_ticket_number = ticket_info.entity_ticket_number
      result = Services::TicketNumberModifier.call(ticket, entity_ticket_increment: 1)
      expect(result.code).to eq(0)
      expect(entity_ticket_number + 1).to eq(ticket_info.reload.entity_ticket_number)
    end

    it '减少实体票成功' do
      entity_ticket_number = ticket_info.entity_ticket_number
      result = Services::TicketNumberModifier.call(ticket, entity_ticket_decrement: 1)
      expect(result.code).to eq(0)
      expect(entity_ticket_number - 1).to eq(ticket_info.reload.entity_ticket_number)
    end
  end

  context '修改票数为0时' do
    it '应返回 修改的票数不能为空或为零' do
      arr = [ {e_ticket_increment: 0}, {e_ticket_decrement: 0}, {entity_ticket_increment: 0}, {entity_ticket_decrement: 0} ]
      arr.each do |hash|
        result = Services::TicketNumberModifier.call(ticket, hash)
        expect(result.code).to eq(1)
        expect(result.msg).to eq('修改的票数不能为空或为零')
      end
    end
  end

  context '当ticket_info lock_version不正确时' do
    it '新增电子票，应返回修改票数失败' do
      m_ticket_info = TicketInfo.find ticket_info.id
      m_ticket_info.e_ticket_sold_number = 10
      m_ticket_info.save
      result = Services::TicketNumberModifier.call(ticket, e_ticket_increment: 1)
      expect(result.code).to eq(1)
      expect(result.msg).to eq('该记录同时被其它人修改,修改票数失败。请重新修改。')
    end

    it '减少电子票，应返回修改票数失败' do
      m_ticket_info = TicketInfo.find ticket_info.id
      m_ticket_info.e_ticket_sold_number = 10
      m_ticket_info.save
      result = Services::TicketNumberModifier.call(ticket, e_ticket_decrement: 1)
      expect(result.code).to eq(1)
      expect(result.msg).to eq('该记录同时被其它人修改,修改票数失败。请重新修改。')
    end

    it '新增实体票，应返回修改票数失败' do
      m_ticket_info = TicketInfo.find ticket_info.id
      m_ticket_info.e_ticket_sold_number = 10
      m_ticket_info.save
      result = Services::TicketNumberModifier.call(ticket, entity_ticket_increment: 1)
      expect(result.code).to eq(1)
      expect(result.msg).to eq('该记录同时被其它人修改,修改票数失败。请重新修改。')
    end

    it '减少实体票，应返回修改票数失败' do
      m_ticket_info = TicketInfo.find ticket_info.id
      m_ticket_info.e_ticket_sold_number = 10
      m_ticket_info.save
      result = Services::TicketNumberModifier.call(ticket, entity_ticket_decrement: 1)
      expect(result.code).to eq(1)
      expect(result.msg).to eq('该记录同时被其它人修改,修改票数失败。请重新修改。')
    end
  end
end