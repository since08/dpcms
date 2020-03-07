module Services
  class RaceSequencer
    include Serviceable
    attr_accessor :race
    DATE_FORMAT_LENGTH = 8

    def initialize(race)
      self.race = race
    end

    def call
      if max_seq_valid?
        max_seq_race.seq_id + 1
      else
        today_first_seq
      end
    end

    def max_seq_race
      @max_seq_race ||= Race.where(begin_date: race.begin_date).seq_desc.first
    end

    def max_seq_valid?
      max_seq_race && max_seq_race.seq_id.to_s.first(DATE_FORMAT_LENGTH) == begin_date_prefix
    end

    def today_first_seq
      "#{begin_date_prefix}001"
    end

    def begin_date_prefix
      race.begin_date.strftime('%Y%m%d')
    end
  end
end

