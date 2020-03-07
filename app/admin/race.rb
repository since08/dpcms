# rubocop:disable Metrics/BlockLength
RACE_STATUSES = Race.statuses.keys
TRANS_RACE_STATUSES = RACE_STATUSES.collect { |d| [I18n.t("race.#{d}"), d] }
TRANS_REQUIRED_ID_TYPES = Race.required_id_types.keys.collect { |d| [I18n.t("required_id_type.#{d}"), d] }
ActiveAdmin.register Race do
  menu priority: 2, parent: '赛事管理', label: '赛事列表'

  config.batch_actions = false
  config.sort_order = 'begin_date_desc'

  filter :name
  filter :location
  filter :begin_date
  filter :race_host
  filter :status, as: :select, collection: TRANS_RACE_STATUSES
  # filter :ticket_status, as: :select, collection: TRANS_TICKET_STATUSES, if: :in_ticket_manage?

  index title: I18n.t('race.list'), as: RacesIndex do
    render 'index', context: self
  end

  # index title: I18n.t('race.ticket_manage'), as: TicketManageIndex do
  #   render 'ticket_manage_index', context: self
  # end

  show do
    render 'show', context: self
  end

  permit_params :name, :logo, :prize, :location, :begin_date, :end_date, :status, :participants,
                :ticket_price, :ticket_sellable, :describable, :race_host_id, :blind, :required_id_type,
                race_en_attributes: [:name, :logo, :prize, :location, :ticket_price, :description],
                race_desc_attributes: [:description],
                race_desc_en_attributes: [:description]
  form partial: 'form'

  controller do
    include RaceHelper
    before_action :unpublished?, only: [:destroy]
    before_action :syn_description, only: [:create]
    before_action :syn_logo, only: [:create]

    def syn_logo
      en_logo = params[:race][:race_en_attributes][:logo] || params[:race][:logo]
      params[:race][:race_en_attributes][:logo] = en_logo
    end

    def syn_description
      return unless params[:race][:race_desc_en_attributes][:description].blank?

      params[:race][:race_desc_en_attributes][:description] = params[:race][:race_desc_attributes][:description]
    end

    def unpublished?
      @race = Race.find(params[:id])
      return unless @race.published?

      flash[:error] = I18n.t('race.destroy_error')
      redirect_back fallback_location: admin_races_url
    end

    def scoped_collection
      chain = super.main
      return chain.ticket_sellable if in_ticket_manage?

      chain
    end
  end

  member_action :change_status, method: :put do
    resource.send("#{params[:status]}!")
    render json: resource
  end

  member_action :publish, method: :post do
    race = Race.find(params[:id])
    race.publish!
    redirect_back fallback_location: admin_races_url, notice: I18n.t('race.publish_notice')
  end

  member_action :unpublish, method: :post do
    Race.find(params[:id]).unpublish!
    redirect_back fallback_location: admin_races_url, notice: I18n.t('race.unpublish_notice')
  end

  member_action :cancel_sell, method: :post do
    race = Race.find(params[:id])
    race.cancel_sell!
    redirect_back fallback_location: admin_races_url, notice: I18n.t('race.cancel_sell_notice')
  end

  member_action :sellable, method: :post do
    race = Race.find(params[:id])
    race.sellable!
    redirect_back fallback_location: admin_races_url, notice: I18n.t('race.sellable_notice')
  end

  action_item :publish, only: :show do
    publish_status_link(race)
  end
end
