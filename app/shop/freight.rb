ActiveAdmin.register Freight, namespace: :shop do
  config.batch_actions = false
  config.filters = false
  config.breadcrumb = false
  actions :all, except: [:new, :destroy, :edit]
  menu priority: 18, parent: '运费管理'

  permit_params :name, :first_cond, :first_price, :add_cond, :add_price

  index download_links: false do
    render 'index'
  end

  show do
    render 'show', freight: resource
  end

  member_action :set_default, method: :post do
    # 先取消所有默认，然后将当前的设为默认
    list = Freight.all
    list.present? && list.map(&:no_default!)
    resource.default!
    redirect_back fallback_location: shop_freights_url, notice: '设置成功'
  end

  member_action :change_view, method: :post do
    respond_to do |format|
      format.js
    end
  end
end
