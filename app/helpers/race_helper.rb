# rubocop:disable Metrics/ModuleLength
module RaceHelper
  def in_ticket_manage?
    params[:as] == I18n.t('race.ticket_manage')
  end

  def in_race_list?
    params[:as] == I18n.t('race.list')
  end

  def publish_status_link(race)
    if race.published?
      link_to I18n.t('race.unpublish'), unpublish_admin_race_path(race), method: :post
    else
      link_to I18n.t('race.publish'), publish_admin_race_path(race), method: :post
    end
  end

  def link_to_race(race)
    if race.parent
      link_to race.name, admin_race_sub_race_path(race.parent, race)
    else
      link_to race.name, admin_race_path(race)
    end
  end

  def logo_link_to_show(race)
    link_to race.logo.url ? image_tag(race.preview_logo, height: 150, width: 105) : '', resource_path(race)
  end

  def race_period(race)
    "#{race.begin_date} 至 #{race.end_date}"
  end

  def format_prize(race)
    race.prize
  end

  def rmb_format(number)
    "RMB #{number}"
  end

  def format_ticket_price(race)
    race.ticket_price
  end

  def show_big_logo_link(race)
    link_to image_tag(race.preview_logo, height: 150), race.big_logo, target: '_blank'
  end

  def select_to_status(race)
    select_tag :status, options_for_select(TRANS_RACE_STATUSES, race.status),
               data: { before_val: race.status, url: change_status_admin_race_path(race) },
               class: 'ajax_change_status'
  end

  def surplus_ticket(ticket_info)
    content_tag :span, "剩余#{ticket_info.surplus_e_ticket}张电子票，#{ticket_info.surplus_entity_ticket}张实体票",
                class: :red, id: :surplus_ticket
  end

  def surplus_e_ticket(ticket_info)
    content_tag :span, "剩余 #{ticket_info.surplus_e_ticket} 张",
                class: :red
  end

  def surplus_entity_ticket(ticket_info)
    content_tag :span, "剩余 #{ticket_info.surplus_entity_ticket} 张",
                class: :red
  end

  def select_to_ticket_status(ticket)
    select_tag :ticket_status, options_for_select(TRANS_TICKET_STATUSES, ticket.status),
               data: { before_val: ticket.status, url: change_status_admin_ticket_path(ticket) },
               class: 'ajax_change_status'
  end

  def index_table_actions(source, race)
    source.item I18n.t('active_admin.edit'), edit_resource_path(race),
                title: I18n.t('active_admin.edit'),
                class: 'edit_link member_link'
    ticket_sellable_link(source, race)
    return if race.published?

    source.item I18n.t('active_admin.delete'), resource_path(race),
                title:  I18n.t('active_admin.delete'),
                class:  'delete_link member_link',
                method: :delete,
                data:   { confirm: I18n.t('active_admin.delete_confirmation') }
  end

  def ticket_table_actions(source, race)
    source.item I18n.t('active_admin.edit'), admin_race_ticket_info_path(race, race.ticket_info),
                title: I18n.t('active_admin.edit'),
                class: 'member_link'

    ticket_sellable_link(source, race)
  end

  def ticket_sellable_link(source, race)
    if race.ticket_sellable
      source.item I18n.t('race.cancel_sell'), cancel_sell_admin_race_path(race),
                  title:  I18n.t('race.cancel_sell'),
                  class:  'member_link',
                  method: :post,
                  data:   { confirm: I18n.t('race.cancel_sell_confirmation') }
    else
      source.item I18n.t('race.sellable'), sellable_admin_race_path(race),
                  title:  I18n.t('race.sellable'),
                  class:  'member_link',
                  method: :post
    end
  end

  def blind_text(blind)
    "#{blind.small_blind} - #{blind.big_blind}"
  end

  def ticket_breadcrumb_path
    return request.path if @race.main?

    if params[:id].present?
      return admin_race_sub_race_ticket_path(@race.parent, @race, @ticket)
    end
    admin_race_sub_race_tickets_path(@race.parent, @race)
  end
end
