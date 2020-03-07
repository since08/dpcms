module Services
  class TicketNumberModifier
    include Serviceable
    attr_accessor :ticket
    delegate :ticket_info, to: :ticket
    def initialize(ticket, params)
      self.ticket = ticket
      @e_ticket_increment      = params[:e_ticket_increment].to_i
      @e_ticket_decrement      = params[:e_ticket_decrement].to_i
      @entity_ticket_increment = params[:entity_ticket_increment].to_i
      @entity_ticket_decrement = params[:entity_ticket_decrement].to_i
    end

    def call
      if @e_ticket_increment.positive?
        increase_e_ticket
      elsif @e_ticket_decrement.positive?
        decrease_e_ticket
      elsif @entity_ticket_increment.positive?
        increase_entity_ticket
      elsif @entity_ticket_decrement.positive?
        decrease_entity_ticket
      else
        ApiResult.error_result(1, '修改的票数不能为空或为零')
      end
    rescue ActiveRecord::StaleObjectError
      ApiResult.error_result(1, '该记录同时被其它人修改,修改票数失败。请重新修改。')
    end

    def increase_e_ticket
      ticket_info.increment_with_lock!(:e_ticket_number, @e_ticket_increment)
      ticket.update(status: 'selling') if ticket.status == 'sold_out'
      ApiResult.success_result
    end

    def decrease_e_ticket
      if ticket_info.surplus_e_ticket < @e_ticket_decrement
        return ApiResult.error_result(1, '减去的票数不允许大于剩余的票数')
      end
      ticket_info.decrement_with_lock!(:e_ticket_number, @e_ticket_decrement)
      ticket.update(status: 'sold_out') if ticket_info.sold_out?
      ApiResult.success_result
    end

    def increase_entity_ticket
      ticket_info.increment_with_lock!(:entity_ticket_number, @entity_ticket_increment)
      ticket.update(status: 'selling') if ticket.status == 'sold_out'
      ApiResult.success_result
    end

    def decrease_entity_ticket
      if ticket_info.surplus_entity_ticket < @entity_ticket_decrement
        return ApiResult.error_result(1, '减去的票数不允许大于剩余的票数')
      end
      ticket_info.decrement_with_lock!(:entity_ticket_number, @entity_ticket_decrement)
      ticket.update(status: 'sold_out') if ticket_info.sold_out?
      ApiResult.success_result
    end
  end
end
