# rubocop:disable Metrics/BlockLength
ActiveAdmin.register FreSpecial, namespace: :shop do
  menu false
  belongs_to :freight, optional: true
  permit_params :first_cond, :first_price, :add_cond, :add_price

  member_action :remote_delete, method: :post do
    resource.destroy
  end

  member_action :add_province_view, method: :post do
  end

  member_action :add_province, method: :post do
    province_list = params[:province]
    # 先清除原有的数据
    resource.fre_special_provinces.map(&:destroy!)
    # return render :add_province unless province_list.present?
    # 根据现有的标签新建数据
    province_list&.each_with_index do |item, _index|
      resource.fre_special_provinces.create(province_id: item[1][:id].to_i, province_name: item[1][:name])
    end
  end

  controller do
    before_action :set_freight, only: [:new, :create]

    def new
      @fre_special = FreSpecial.new
    end

    def create
      create_data =  @freight.present? ? create_params.merge!(freight: @freight) : create_params
      @fre_special = FreSpecial.new(create_data)
      respond_to do |format|
        if @fre_special.save
          flash[:notice] = '新建成功'
          format.html { redirect_to shop_fre_special_url(@fre_special) }
        else
          format.html { render :new }
        end
        format.js
      end
    end

    private

    def create_params
      params.require(:fre_special).permit(:first_cond, :first_price, :add_cond, :add_price)
    end

    def set_freight
      @freight = params[:freight_id] && Freight.find(params[:freight_id])
    end
  end
end
