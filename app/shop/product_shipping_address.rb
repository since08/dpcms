ActiveAdmin.register ProductShippingAddress, namespace: :shop do
  config.batch_actions = false
  menu false

  member_action :change_address, method: [:get, :post] do
    return render :change_address unless request.post?
    reason = params[:change_reason]
    memo = params[:memo]
    resource.update(change_reason: reason, memo: memo)
    redirect_back fallback_location: shop_product_shipping_address_url
  end
end