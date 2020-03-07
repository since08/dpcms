# rubocop:disable Metrics/BlockLength
PRODUCT_REFUND_STATES = ProductRefund.statuses.keys
TRANS_REFUND_STATES = PRODUCT_REFUND_STATES.collect { |d| [I18n.t("product_refund.#{d}"), d] }
ActiveAdmin.register ProductRefund, namespace: :shop do
  menu priority: 3, parent: '订单管理'
  config.batch_actions = false
  config.clear_action_items!

  filter :status, as: :select, collection: TRANS_REFUND_STATES

  index do
    render 'index', context: self
  end

  show do
    render 'show'
  end

  member_action :agree_refund, method: [:get, :patch] do
    @refund = ProductRefund.find(params[:id])
    return render layout: false if request.get?

    if params[:confirm_code] != 'confirm'
      flash[:error] = '输入确认码有误'
      return redirect_back fallback_location: shop_product_refunds_url
    end

    result = Services::ShopOrders::RefundService.call(@refund)
    if result.failure?
      flash[:error] = result.msg
      return redirect_back fallback_location: shop_product_refunds_url
    end
    redirect_back fallback_location: shop_product_refunds_url, notice: '退款成功'
  end

  member_action :reject_refund, method: [:get, :patch] do
    @refund = ProductRefund.find(params[:id])

    return render layout: false if request.get?

    @refund.admin_memo = params[:product_refund][:admin_memo]
    @refund.close_all!
    redirect_back fallback_location: shop_product_refunds_url, notice: '已拒绝退款'
  end
end
