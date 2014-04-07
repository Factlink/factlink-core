module Interactors
  module Facts
    class RemoveOpinion
      include Pavlov::Interactor

      arguments :fact_id

      def execute
        Backend::Facts.remove_opinion \
          fact_id: fact_id,
          graph_user_id: pavlov_options[:current_user].graph_user_id

        Backend::Facts.get(fact_id: fact_id)
      end

      def validate
        validate_integer_string :fact_id, fact_id
      end

      def authorized?
        pavlov_options[:current_user]
      end
    end
  end
end
