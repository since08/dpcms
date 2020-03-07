module Services
  module Players
    class FilteringService
      include Serviceable
      include Constants::Error::Common

      def initialize(collection, filter_params)
        @region = filter_params[:region].to_i
        @year = filter_params[:year].to_i
        @collection = collection
      end

      def call
        join_where = "INNER JOIN races ON races.begin_date >= '#{year_first_day}'
AND races.begin_date <= '#{year_last_day}' AND races.id = race_ranks.race_id"
        players = @collection.joins(join_where).joins(:race_ranks).group(:id)
                             .select('players.*', 'SUM(earning) AS dpi_total_earning')
                             .earn_order
        filtering_region players
      end

      def year_first_day
        "#{@year}-01-01"
      end

      def year_last_day
        "#{@year}-12-31"
      end

      def filtering_region(relation)
        return relation if @region == 'global'

        relation.where('country like ?', '%中国')
      end
    end
  end
end
