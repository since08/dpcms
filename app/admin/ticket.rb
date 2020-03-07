# rubocop:disable Metrics/BlockLength
TICKET_CLASSES = Ticket.ticket_classes.keys
TRANS_TICKET_CLASSES = TICKET_CLASSES.collect { |d| [I18n.t("ticket.ticket_class.#{d}"), d] }
TICKET_ROLE_GROUPS = Ticket.role_groups.keys
TRANS_ROLE_GROUPS = TICKET_ROLE_GROUPS.collect { |d| [I18n.t("ticket.role_group.#{d}"), d] }
TICKET_STATUSES = Ticket.statuses.keys
TRANS_TICKET_STATUSES = TICKET_STATUSES.collect { |d| [I18n.t("ticket.status.#{d}"), d] }

ActiveAdmin.register Ticket do
  menu false
  belongs_to :race, optional: true
  belongs_to :sub_race, optional: true
  config.filters = false
  config.batch_actions = false
  config.sort_order = 'level_asc'
  breadcrumb do
    breadcrumb_links(ticket_breadcrumb_path)
  end

  permit_params :title, :description, :price, :original_price, :ticket_class,
                :status, :banner, :logo, :level, :role_group,
                ticket_en_attributes: [:title, :description, :price, :original_price, :banner, :logo],
                ticket_info_attributes: [:e_ticket_number, :entity_ticket_number]

  form partial: 'form'

  index download_links: false do
    render 'index', context: self
  end

  show do
    render 'show', race: race, ticket: ticket, ticket_info: ticket.ticket_info
  end

  controller do
    before_action :syn_image, only: [:create]
    before_action :exist_orders?, only: [:destroy]

    def syn_image
      en_logo = params[:ticket][:ticket_en_attributes][:logo] || params[:ticket][:logo]
      params[:ticket][:ticket_en_attributes][:logo] = en_logo
      en_banner = params[:ticket][:ticket_en_attributes][:banner] || params[:ticket][:banner]
      params[:ticket][:ticket_en_attributes][:banner] = en_banner
    end

    def exist_orders?
      @ticket = Ticket.find(params[:id])
      return unless @ticket.orders.exists?

      flash[:error] = '该票务已有订单，不允许删除'
      redirect_back fallback_location: admin_race_tickets_url(params[:race_id])
    end
  end

  member_action :change_number, method: :post do
    result = Services::TicketNumberModifier.call(resource, params)
    if result.failure?
      flash[:error] = result.msg
    else
      flash[:success] = '票数修改成功'
    end
    redirect_to action: :show
  end

  member_action :change_status, method: :put do
    resource.send("#{params[:status]}!")
    render json: resource
  end
end
