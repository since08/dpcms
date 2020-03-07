# rubocop:disable Metrics/BlockLength
ActiveAdmin.register Player do
  menu priority: 2, parent: '赛事管理', label: '牌手管理'
  filter :year, lable: '年份'
  filter :player_id
  filter :name
  filter :country

  index title: I18n.t('player.list') do
    column :player_id
    column '头像', :avatar do |player|
      if player.avatar_thumb.present?
        link_to image_tag(player.avatar_thumb, height: 100), player.avatar_thumb, target: '_blank'
      end
    end
    column :name
    column :nick_name
    column :country
    column :dpi_total_earning
    column :dpi_total_score
    column :follows_count
    column :memo
    actions name: '操作'
  end

  show do
    render 'show', context: self
  end

  form partial: 'form'

  controller do
    before_action :set_player, only: [:edit, :update]

    def find_collection
      filter_params = params[:q] || {}
      return super if filter_params[:year_contains].blank?

      filter_params[:year] = filter_params[:year_contains]
      Services::Players::FilteringService.call(super.unscoped, filter_params)
                                         .page(params[:page]).per(30)
    end

    def new
      @player = Player.new
    end

    def create
      @player = Player.new(player_params)
      respond_to do |format|
        if @player.save
          flash[:notice] = '新建牌手成功'
          format.html { redirect_to admin_player_url(@player) }
        else
          format.html { render :new }
        end
        format.js
      end
    end

    def edit
      render :new
    end

    def update
      @player.crop_x = player_params[:crop_x]
      @player.crop_y = player_params[:crop_y]
      @player.crop_w = player_params[:crop_w]
      @player.crop_h = player_params[:crop_h]
      @player.assign_attributes(player_params)
      respond_to do |format|
        if @player.save
          flash[:notice] = '更新牌手成功'
          format.html { redirect_to admin_player_url(@player) }
        else
          format.html { render :edit }
        end
        format.js { render :create }
      end
    end

    def destroy
      if resource.race_ranks.exists?
        flash[:notice] = '排名表中已存在的牌手不可删除'
      else
        resource.destroy
      end
      redirect_to admin_players_url
    end

    def player_params
      params.require(:player).permit(:name,
                                     :nick_name,
                                     :avatar,
                                     :country,
                                     :dpi_total_earning,
                                     :dpi_total_score,
                                     :memo,
                                     :crop_x, :crop_y, :crop_w, :crop_h)
    end

    def set_player
      @player = Player.find(params[:id])
    end
  end

  sidebar :'牌手数量', only: :index do
    "牌手总数量：#{Player.count}名"
  end

  action_item :import, only: :index do
    link_to '批量导入', import_admin_players_path, remote: true
  end

  collection_action :import, method: [:get, :post] do
    return render :import unless request.post?

    file = params[:file]
    if file.blank? || !File.extname(file.original_filename).in?(%w(.xls .xlsx))
      flash[:error] = '文件格式有误， 只能为xls 或 xlsx'
    else
      success_num = 0
      total_num = 0
      spreadsheet = Roo::Spreadsheet.open(file.path)
      (2..spreadsheet.last_row).each do |i|
        row = spreadsheet.row(i)
        player = Player.new(name: row[0], country: row[1])
        success_num += 1 if player.save
        total_num += 1
      end
      flash[:notice] = "总计 #{total_num} 个牌手， 成功导入 #{success_num} 个牌手"
    end
    redirect_to action: :index
  end
end
