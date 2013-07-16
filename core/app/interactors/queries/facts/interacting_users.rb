require 'pavlov'
require_relative '../../kill_object'
require 'andand'

module Queries
  module Facts
    class InteractingUsers
      include Pavlov::Query

      arguments :fact_id, :skip, :take, :opinion

      def execute
        graph_users= users_who(@opinion)
        paginated_users = paginate(graph_users).map(&:user)

        {
          users: paginated_users.map{|u| KillObject.user u},
          total: graph_users.size
        }
      end

      def paginate(data)
        data.drop(@skip).take(@take)
      end

      def users_who(opinion)
        Fact[@fact_id].send("people_#{opinion}").to_a
      end
    end
  end
end
