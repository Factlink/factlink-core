require_relative '../../kill_object'

module Queries
  module Facts
    class Opinionators
      include Pavlov::Query

      arguments :fact_id, :opinion

      private

      def execute
        users.map { |u| KillObject.user u }
      end

      def users
        users_who(opinion).map(&:user)
      end

      def users_who(type)
        Fact[fact_id].opiniated(type).to_a
      end
    end
  end
end
