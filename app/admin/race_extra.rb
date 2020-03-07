# rubocop:disable Metrics/BlockLength
ActiveAdmin.register RaceExtra do
  belongs_to :race, singleton: true
  config.batch_actions = false
  config.breadcrumb = false
  actions :nil
  menu false
  navigation_menu :default

  permit_params :blind_memo, :schedule_memo,
                race_extra_en_attributes: [:blind_memo, :schedule_memo]
  controller do
    before_action :set_race
    before_action :set_race_extra

    def set_race
      @race = Race.find(params[:race_id])
    end

    def set_race_extra
      @race_extra = @race.race_extra || @race.build_race_extra
    end
  end

  collection_action :edit_blind, method: :get do
    @page_title = '盲注备注'
    render '/admin/race_extra/edit_blind'
  end

  collection_action :edit_schedule, method: :get do
    @page_title = '赛程备注'
    render '/admin/race_extra/edit_schedule'
  end

  collection_action :quick_update, method: :post do
    @race_extra.assign_attributes(permitted_params[:race_extra])
    @race_extra.save
    redirect_back fallback_location: admin_race_url(@race), notice: '编辑成功'
  end
end
