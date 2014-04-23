module Interactors
  module Facts
    class Votes
      include Pavlov::Interactor
      include Util::CanCan

      arguments :fact_id

      def execute
        Backend::Facts.votes(fact_id: fact_id).map do |vote|
          {
            username: vote[:user].username,
            user: vote[:user]
          }
        end
      end

      def authorized?
        true
      end

      def validate
        validate_integer_string :fact_id, fact_id
      end
    end
  end
end
