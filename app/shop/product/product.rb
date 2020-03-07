# rubocop:disable Metrics/BlockLength
PRODUCT_TYPES = Product.product_types.keys
TRANS_PRODUCT_TYPES = PRODUCT_TYPES.collect { |d| [I18n.t("product.#{d}"), d] }
ActiveAdmin.register Product, namespace: :shop do
  config.batch_actions = false
  config.sort_order = 'published_desc'
  menu priority: 2

  filter :title
  filter :published
  filter :recommended
  filter :by_root_category_in, label: '主类别', as: :select, collection: Category.roots_collection

  permit_params :title, :description, :product_type, :category_id, :recommended,
                :published, :freight_id, :freight_free, :seven_days_return,
                :crop_x, :crop_y, :crop_w, :crop_h, :icon,
                master_attributes: [:original_price, :price, :stock,
                                    :volume, :origin_point, :weight]

  sidebar '侧边栏', only: [:edit, :update, :variants] do
    product_sidebar_generator(self)
  end

  form partial: 'form'

  index do
    render 'index', context: self
  end

  controller do
    def create
      @product = Product.new(permitted_params[:product])
      if @product.save
        flash[:notice] = '新建商品详情成功'
        redirect_to edit_shop_product_path(@product)
      else
        render :new
      end
    end

    def update
      @product = Product.find(params[:id])
      @product.assign_attributes(permitted_params[:product])
      unless params[:remote_img_url].blank?
        @product.remote_icon_url = params[:remote_img_url]
      end
      if @product.save
        flash[:notice] = '修改商品详情成功'
        redirect_to edit_shop_product_path(@product)
      else
        flash[:error] = '修改商品详情失败'
        render :edit
      end
    end
  end

  member_action :publish, method: :post do
    Product.find(params[:id]).publish!
    redirect_back fallback_location: shop_products_url, notice: '上架商品成功'
  end

  member_action :unpublish, method: :post do
    Product.find(params[:id]).unpublish!
    redirect_back fallback_location: shop_products_url, notice: '已下架商品'
  end

  member_action :recommend, method: :post do
    Product.find(params[:id]).recommend!
    redirect_back fallback_location: shop_products_url, notice: '推荐商品成功'
  end

  member_action :unrecommend, method: :post do
    Product.find(params[:id]).unrecommend!
    redirect_back fallback_location: shop_products_url, notice: '已取消推荐商品'
  end
end
