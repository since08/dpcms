# rubocop:disable Metrics/BlockLength
ActiveAdmin.register RaceRank do
  config.filters = false
  config.batch_actions = false
  config.sort_order = 'ranking_asc'
  breadcrumb do
    if race.main?
      breadcrumb_links
    else
      path = admin_race_sub_race_race_blinds_path(race.parent, race)
      breadcrumb_links(path)
    end
  end

  belongs_to :race
  belongs_to :sub_race, optional: true

  navigation_menu :default
  menu false

  index title: proc { "#{@race.name} - 排行榜" }, download_links: false do
    render 'index', context: self
  end

  controller do
    before_action :set_race, only: [:new, :create, :edit, :update]
    before_action :set_race_rank, only: [:edit, :update]

    def new
      @race_rank = @race.race_ranks.build
    end

    def edit
      render :new
    end

    def create
      @race_rank = @race.race_ranks.build(rank_params)
      flash[:notice] = '新建排名成功' if @race_rank.save
    end

    def update
      @race_rank.assign_attributes(rank_params)
      flash[:notice] = '更新排名成功' if @race_rank.save
      render :create
    end

    def destroy
      resource.destroy
      redirect_back fallback_location: admin_race_race_ranks_path(@race)
    end

    private

    def rank_params
      params.require(:race_rank).permit(:ranking,
                                        :earning,
                                        :score,
                                        :player_id)
    end

    def set_race
      @race = Race.find(params[:race_id])
    end

    def set_race_rank
      @race_rank = @race.race_ranks.find(params[:id])
    end
  end

  member_action :player_table, method: :get do
    render 'player_table'
  end

  config.clear_action_items!
  action_item :add, only: :index do
    link_to '新增排名', new_admin_race_race_rank_path(race), remote: true
  end

  action_item :import, only: :index do
    link_to '批量导入', import_admin_race_race_ranks_path(race), remote: true
  end

  collection_action :import, method: [:get, :post] do
    @race = Race.find(params[:race_id])
    return render :import unless request.post?

    file = params[:file]
    if file.blank? || !File.extname(file.original_filename).in?(%w(.xls .xlsx))
      flash[:error] = '文件格式有误， 只能为xls 或 xlsx'
    else
      success_num = 0
      total_num = 0
      spreadsheet = Roo::Spreadsheet.open(file.path)
      (2..spreadsheet.last_row).each do |i|
        total_num += 1
        row = spreadsheet.row(i)
        player = Player.find_by(name: row[0])
        next unless player

        rank = RaceRank.new(race: @race, player: player,
                            ranking: row[1], earning: row[2], score: row[3])
        success_num += 1 if rank.save
      end
      flash[:notice] = "总计 #{total_num} 个排名， 成功导入 #{success_num} 个排名"
    end
    redirect_to action: :index
  end
end
