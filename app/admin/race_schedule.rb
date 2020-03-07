# rubocop:disable Metrics/BlockLength
ActiveAdmin.register RaceSchedule do
  belongs_to :race
  belongs_to :sub_race, optional: true
  config.filters = false
  config.batch_actions = false
  config.sort_order = ''
  breadcrumb do
    if race.main?
      breadcrumb_links
    else
      path = admin_race_sub_race_race_blinds_path(race.parent, race)
      breadcrumb_links(path)
    end
  end

  navigation_menu :default
  menu false

  # permit_params :schedule, :begin_time,
  #               race_schedule_en_attributes: [:schedule]

  form partial: 'form'

  index download_links: false do
    render 'index', context: self
  end

  controller do
    before_action :set_race, only: [:create, :update]
    before_action :set_race_schedule, only: [:update]

    def create
      @race_schedule = @race.race_schedules.build(schedule_params)
      if @race_schedule.save
        flash[:notice] = '新建赛程表成功'
        redirect_to admin_race_race_schedules_url
      else
        flash[:notice] = '新建赛程表失败'
        render :new
      end
    end

    def update
      @race_schedule.assign_attributes(schedule_params)
      if @race_schedule.save
        flash[:notice] = '更新赛程表成功'
        redirect_to admin_race_race_schedules_url
      else
        flash[:notice] = '更新赛程表失败'
        render :edit
      end
    end

    def scoped_collection
      super.default_asc
    end

    private

    def schedule_params
      params.require(:race_schedule).permit(:schedule,
                                            :begin_time,
                                            race_schedule_en_attributes: [:schedule])
    end

    def set_race
      @race = Race.find(params[:race_id])
    end

    def set_race_schedule
      @race_schedule = @race.race_schedules.find(params[:id])
    end
  end

  action_item :memo, only: :index do
    link_to '编辑备注', edit_schedule_admin_race_race_extras_path(race), target: '_blank'
  end
end
