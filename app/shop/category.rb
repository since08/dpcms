# rubocop:disable Metrics/BlockLength
ActiveAdmin.register Category, namespace: :shop do
  config.batch_actions = false
  config.filters = false
  config.breadcrumb = false
  config.paginate = false
  actions :all, except: :index
  menu priority: 1

  permit_params :name, :image, :parent_id
  form do |f|
    f.inputs do
      f.input :name
      f.input :image
    end
    f.actions
  end

  # index as: IndexAsCategory, download_links: false, paginator: false, pagination_total: false

  action [], :index, method: :get do
    render layout: 'layouts/active_admin'
  end

  collection_action :quick_add, method: :get do
    @category = Category.new(parent_id: params[:parent_id])
    render layout: false
  end

  member_action :quick_edit, method: :get do
    @category = Category.find(params[:id])
    render layout: false
  end

  member_action :quick_update, method: :patch do
    @category = Category.find(params[:id])
    @category.update(permitted_params[:category])
    render 'quick_response', layout: false
  end

  collection_action :quick_create, method: :post do
    @category = Category.new(permitted_params[:category])
    # @category = Category.new(params[:category].as_json)
    @category.save
    render 'quick_response', layout: false
  end

  member_action :children, method: :get do
    @category = Category.find(params[:id])
    respond_to do |format|
      format.js { render 'children', layout: false }
      format.json { render json: @category.children }
    end
  end

  controller do
    before_action :deletable?, only: [:destroy]

    def deletable?
      @category = Category.find(params[:id])
      return if @category.children_count.zero? && @category.products.count.zero?

      flash[:error] = '该类别下有子分类或者商品，不允许删除'
      redirect_back fallback_location: shop_categories_url
    end
  end
end
