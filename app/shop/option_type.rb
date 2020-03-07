ActiveAdmin.register OptionType, namespace: :shop do
  config.batch_actions = false

  belongs_to :product, optional: true
  navigation_menu :default
  menu false
  actions :nil

  permit_params :name, :product_id

  collection_action :quick_new, method: :get do
    @product = Product.find(params[:product_id])
    @option_type = OptionType.new(product: @product)
    render 'new', layout: false
  end

  collection_action :quick_create, method: :post do
    @option_type = OptionType.new(permitted_params[:option_type])
    @option_type.save
    render 'quick_response', layout: false
  end

  collection_action :destroy, method: :delete do
    @option_type = OptionType.find(params[:id])
    has_values = @option_type.option_values.exists?
    @option_type.destroy
    @option_type.product.rebuild_variants_for_type_delete(has_values)
    redirect_back fallback_location: shop_product_variants_path(params[:product_id])
  end
end
