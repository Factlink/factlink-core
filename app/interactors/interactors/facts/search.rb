module Interactors
  module Facts
    class Search
      include Pavlov::Interactor
      include Util::CanCan

      arguments :keywords

      def execute
        facts = FactData.search_by_content(keywords)
        facts.map do |fact|
          Backend::Facts.get_by_fact_data_id fact_data_id: fact.id
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
