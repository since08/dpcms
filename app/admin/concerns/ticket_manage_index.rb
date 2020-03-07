class TicketManageIndex < ActiveAdmin::Views::IndexAsTable
  def self.index_name
    I18n.t('race.ticket_manage')
  end
end
