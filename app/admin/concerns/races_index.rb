class RacesIndex < ActiveAdmin::Views::IndexAsTable
  def self.index_name
    I18n.t('race.list')
  end
end
