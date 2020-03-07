# rubocop:disable Metrics/MethodLength
module Services
  module ShopOrders
    class RefundService
      include Serviceable
      include Constants::Error::Common

      def initialize(refund)
        @refund = refund
      end

      def call
        return error_result(ERROR_NOTICE, '退款状态不是待审核中，不允许退款') unless @refund.open?

        # 只需要退扑客币
        if @refund.refund_price <= 0
          refund_poker_coins(@refund.product_order, @refund.refund_poker_coins)
          @refund.complete_all!
          restock_when_undelivered
          return ApiResult.success_result
        end

        result = WxPay::Service.invoke_refund(refund_params)
        Rails.logger.info("ShopOrders::RefundService number=#{@refund.refund_number}: #{result}")
        unless sign_correct?(result[:raw]['xml'])
          return error_result(ERROR_NOTICE, '验证签名失败')
        end

        unless result.success?
          return error_result(ERROR_NOTICE, result['err_code_des'])
        end

        # 看是否还有扑客币需要退
        refund_poker_coins(@refund.product_order, @refund.refund_poker_coins) if @refund.refund_poker_coins.positive?

        @refund.complete_all!
        restock_when_undelivered
        ApiResult.success_result
      end

      # 未发货的时候，恢复库存
      def restock_when_undelivered
        return unless @refund.product_order.product_shipment.nil?

        @refund.product_refund_details.each do |item|
          variant = item.product_order_item.variant
          variant.increase_stock(item.product_order_item.number)
          next if variant.is_master?

          variant.product.master.increase_stock(item.product_order_item.number)
        end
      end

      private

      def sign_correct?(result)
        WxPay::Sign.verify?(result)
      end

      def refund_params
        {
          out_refund_no: @refund.refund_number,
          out_trade_no: @refund.product_order.order_number,
          refund_fee: (@refund.refund_price * 100).to_i,
          total_fee: (@refund.product_order.final_price * 100).to_i
        }
      end

      def refund_poker_coins(order, numbers)
        PokerCoin.deduction(order, '商城订单退款返还扑客币', numbers, '+')
        order.update(deduction_result: 'success', refund_poker_coins: @refund.refund_poker_coins)
      end
    end
  end
end
