module Interactors
  module Facts
    class SetOpinion
      include Pavlov::Interactor

      arguments :fact_id, :opinion

      def execute
        Backend::Facts.set_interesting \
          fact_id: fact_id,
          user_id: pavlov_options[:current_user].id

        Backend::Facts.get(fact_id: fact_id)
      end

      def validate
        validate_integer_string :fact_id, fact_id
        validate_in_set :opinion, opinion, ['believes', 'disbelieves']
      end

      def authorized?
        pavlov_options[:current_user]
      end
    end
  end
end
