module Interactors
  module Facts
    class Search
      include Pavlov::Interactor
      include Util::CanCan

      arguments :keywords

      def execute
        records = ElasticSearch::Search.search keywords: keywords, types: [:factdata]

        records.map do |record|
          Backend::Facts.get_by_fact_data_id fact_data_id: record['_id']
        end
      end

      def validate
        validate_nonempty_string :keywords, keywords
      end

      def authorized?
        true
      end
    end
  end
end
