# rubocop:disable Metrics/BlockLength
RACE_BLIND_TYPES = RaceBlind.blind_types.keys
TRANS_BLIND_TYPES = RACE_BLIND_TYPES.collect { |d| [I18n.t("race_blind.#{d}"), d] }
ActiveAdmin.register RaceBlind do
  config.filters = false
  config.batch_actions = false
  config.paginate = false
  config.sort_order = ''
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

  index download_links: false do
    render 'custom_index', race_blinds: race_blinds
  end
  form partial: 'form'
  controller do
    before_action :set_race, only: [:new, :create, :edit, :update]
    before_action :set_race_blind, only: [:edit, :update]

    def new
      @race_blind = @race.race_blinds.build
    end

    def edit
      render :new
    end

    def create
      last_blind = @race.race_blinds.position_asc.last
      position = last_blind&.position.to_i + 100000
      @race_blind = @race.race_blinds.build(blind_params.merge(position: position))
      flash[:notice] = '新建成功' if @race_blind.save
    end

    def update
      @race_blind.assign_attributes(blind_params)
      flash[:notice] = '更新成功' if @race_blind.save
      render :create
    end

    def scoped_collection
      super.position_asc
    end

    private

    def blind_params
      params.require(:race_blind).permit(:level,
                                         :small_blind,
                                         :big_blind,
                                         :race_time,
                                         :content,
                                         :blind_type,
                                         :ante,
                                         race_blind_en_attributes: [:content])
    end

    def set_race
      @race = Race.find(params[:race_id])
    end

    def set_race_blind
      @race_blind = @race.race_blinds.find(params[:id])
    end
  end

  config.clear_action_items!
  action_item :add, only: :index do
    link_to '新增盲注结构', new_admin_race_race_blind_path(race), remote: true
  end

  action_item :import, only: :index do
    link_to '批量导入', import_admin_race_race_blinds_path(race), remote: true
  end

  action_item :memo, only: :index do
    link_to '编辑备注', edit_blind_admin_race_race_extras_path(race), target: '_blank'
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
        row = spreadsheet.row(i)
        if row[0] == '盲注结构'
          attrs = { blind_type: 0, level: row[1], small_blind: row[2],
                    big_blind: row[3], ante: row[4], race_time: row[5] }
        else
          attrs = { blind_type: 1, level: row[1], content: row[2] }
        end
        last_blind = @race.race_blinds.position_asc.last
        position = last_blind&.position.to_i + 100000
        blind = RaceBlind.new(attrs.merge(race: @race, position: position))
        if blind.save
          success_num += 1
          blind.build_race_blind_en.save
        end
        total_num += 1
      end
      flash[:notice] = "总计 #{total_num} 个盲注， 成功导入 #{success_num} 个盲注"
    end
    redirect_to action: :index
  end

  member_action :reposition, method: :post do
    blind = RaceBlind.find(params[:id])
    next_blind = params[:next_id] && RaceBlind.find(params[:next_id].split('_').last)
    prev_blind = params[:prev_id] && RaceBlind.find(params[:prev_id].split('_').last)
    position = if params[:prev_id].blank?
                 next_blind.position / 2
               elsif params[:next_id].blank?
                 prev_blind.position + 100000
               else
                 (prev_blind.position + next_blind.position) / 2
               end
    blind.update(position: position)
  end
end
