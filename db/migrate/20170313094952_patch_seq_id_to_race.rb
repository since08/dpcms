class PatchSeqIdToRace < ActiveRecord::Migration[5.0]
  def change
    require_dependency 'race_sequencer'
    Race.find_each do |race|
      race.begin_date_will_change!
      race.save
    end
  end
end
