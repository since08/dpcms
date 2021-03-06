ActiveAdmin.register OptionValue, namespace: :shop do
  config.batch_actions = false

  belongs_to :option_type, optional: true
  navigation_menu :default
  menu false
  actions :nil

  permit_params :name, :option_type_id

  collection_action :quick_new, method: :get do
    @option_type = OptionType.find(params[:option_type_id])
    @option_value = OptionValue.new(option_type: @option_type)
    render 'new', layout: false
  end

  collection_action :quick_create, method: :post do
    @option_value = OptionValue.new(permitted_params[:option_value])
    @option_value.save
    @option_value.option_type.product.rebuild_variants_for_value_change
    render 'quick_response', layout: false
  end

  collection_action :destroy, method: :delete do
    @option_value = OptionValue.find(params[:id])
    @option_value.destroy
    @option_value.option_type.product.rebuild_variants_for_value_change
    redirect_back fallback_location: shop_product_variants_path(params[:product_id])
  end
end
