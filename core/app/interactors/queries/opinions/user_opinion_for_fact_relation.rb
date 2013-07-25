module Queries
  module Opinions
    class UserOpinionForFactRelation
      include Pavlov::Query

      arguments :fact_relation
      attribute :pavlov_options, Hash, default: {}

      private

      def execute
        fact_relation.get_user_opinion
      end

      def validate
        validate_not_nil :fact_relation, fact_relation
      end
    end
  end
end
