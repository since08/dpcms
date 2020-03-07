# rubocop:disable Metrics/BlockLength
ActiveAdmin.register ExpressCode, namespace: :shop do
  config.clear_action_items!
  config.batch_actions = false
  config.sort_order = 'published_desc'
  menu priority: 19, parent: '运费管理'
  permit_params :phone, :site

  filter :name
  filter :express_code

  index download_links: false do
    column :id
    column :name, sortable: false
    column :express_code
    column :region do |express_code|
      I18n.t("express_code.#{express_code.region}")
    end
    column(:phone) { |i| best_in_place i, :phone, as: 'input', place_holder: '点我添加', url: [:shop, i] }
    column(:site) { |i| best_in_place i, :site, as: 'input', place_holder: '点我添加', url: [:shop, i] }
    column :published
    actions name: '操作', defaults: false do |express_code|
      str = express_code.published ? '关闭' : '开启'
      item str, open_or_close_shop_express_code_path(express_code), method: :post
    end
  end

  member_action :open_or_close, method: :post do
    resource.toggle_status
    redirect_back fallback_location: shop_express_codes_url, notice: '修改成功'
  end

  action_item :add, only: :index do
    link_to '快递查询', express_search_shop_express_codes_path
  end

  collection_action :express_search, title: '快递查询', method: :get do
    render 'express_search'
  end
end
