# rubocop:disable Metrics/BlockLength
ActiveAdmin.register Race, as: 'SubRace' do
  config.filters = false
  config.batch_actions = false

  belongs_to :race
  navigation_menu :default
  menu false

  index title: proc { @race.name } do
    render 'index', context: self
  end

  show do
    render 'show', context: self
  end

  permit_params :name, :logo, :prize, :location, :begin_date, :end_date, :status,
                :roy, :schedule_begin_time, :ticket_price, :ticket_sellable,
                :describable, :parent_id, :blind, :participants,
                race_en_attributes: [:name, :logo, :prize, :location, :ticket_price, :blind],
                race_desc_attributes: [:schedules],
                race_desc_en_attributes: [:schedules]
  form partial: 'form'

  controller do
    before_action :syn_schedules, only: [:create]
    before_action :unpublished?, only: [:destroy]

    def syn_schedules
      return unless params[:race][:race_desc_en_attributes][:schedules].blank?

      params[:race][:race_desc_en_attributes][:schedules] = params[:race][:race_desc_attributes][:schedules]
    end

    def destroy
      @sub_race.destroy
      redirect_to admin_race_sub_races_url
    end

    def unpublished?
      @sub_race = Race.find(params[:id])
      return unless @sub_race.published?

      flash[:error] = I18n.t('race.destroy_error')
      redirect_back fallback_location: admin_race_sub_races_url
    end
  end

  action_item :publish, only: :show do
    publish_status_link(sub_race)
  end
end
