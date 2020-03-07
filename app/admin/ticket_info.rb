ActiveAdmin.register TicketInfo do
  menu false

  # navigation_menu :default
  # menu false
  # breadcrumb do
  #   path = admin_race_ticket_infos_path(race)
  #   breadcrumb_links(path)
  # end
  #
  # show title: I18n.t('race.ticket_manage') do
  #   render 'show', race: race, ticket_info: race.ticket_info
  # end
  #
  # controller do
  #   def find_resource
  #     @race ||= Race.find(params[:race_id])
  #     @race.ticket_info
  #   end
  # end
  #
  # member_action :change_number, method: :post do
  #   result = Services::TicketNumberModifier.call(resource, params)
  #   if result.failure?
  #     flash[:error] = result.msg
  #   else
  #     flash[:success] = '票数修改成功'
  #   end
  #   redirect_to admin_race_ticket_info_path(@race, resource)
  # end
  #
  # config.clear_action_items!
  # action_item :back, only: :show do
  #   link_to '返回', admin_race_path(race)
  # end
end
