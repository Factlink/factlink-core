module Interactors
  module Facts
    class Votes
      include Pavlov::Interactor
      include Util::CanCan

      arguments :fact_id

      def execute
        votes_for('believes') +
          votes_for('disbelieves') +
          votes_for('doubts')
      end

      def votes_for type
        query(:'facts/opinionators', fact: fact, type: type)
          .map { |user| { user: user, type: type } }
      end

      def fact
        @fact ||= query(:'facts/get', id: fact_id)
      end

      def authorized?
        can? :show, Fact
      end

      def validate
        validate_integer_string :fact_id, fact_id
      end
    end
  end
end
