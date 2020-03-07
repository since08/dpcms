module Services
  module Orders
    class CancelOrderService
      include Serviceable
      include Constants::Error::Order
      attr_accessor :order, :user

      def initialize(order, user = nil)
        self.order = order
        self.user  = user
      end

      def call
        return error_result(CANNOT_CANCEL) unless order.status == 'unpaid'

        order.update(status: 'canceled')
        if order.ticket_type == 'e_ticket'
          order.ticket.return_a_e_ticket
        else
          order.ticket.return_a_entity_ticket
        end
        ApiResult.success_result
      end
    end
  end
end
