# rubocop:disable Metrics/BlockLength
ActiveAdmin.register ProductShipment, namespace: :shop do
  belongs_to :product_order
  menu false
  navigation_menu :default

  controller do
    before_action :set_product_order, only: [:new, :create, :edit, :update]
    before_action :set_product_shipment, only: [:edit, :update]

    def new
      @product_shipment = ProductShipment.new(product_order: @product_order)
    end

    def edit; end

    def update
      shipping_company = ExpressCode.find(product_shipment_params[:express_code_id])&.name
      update_params = product_shipment_params.merge!(shipping_company: shipping_company)
      @product_shipment.update!(update_params)
    end

    def create
      shipping_company = ExpressCode.find(product_shipment_params[:express_code_id])&.name
      update_params = product_shipment_params.merge!(shipping_company: shipping_company, product_order: @product_order)
      return render :repeat_error unless @product_order.product_shipment.blank?
      @product_shipment = ProductShipment.new(update_params)
      @product_order.delivered! if @product_shipment.save
    end

    def set_product_order
      @product_order = ProductOrder.find(params[:product_order_id])
    end

    def set_product_shipment
      @product_shipment = ProductShipment.find(params[:id])
    end

    def product_shipment_params
      params.require(:product_shipment).permit(:express_code_id,
                                               :shipping_number)
    end
  end
end