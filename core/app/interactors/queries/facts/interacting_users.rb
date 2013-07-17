require 'pavlov'
require_relative '../../kill_object'

module Queries
  module Facts
    class InteractingUsers
      include Pavlov::Query

      arguments :fact_id, :skip, :take, :opinion

      private

      def execute

        paginated_users = paginate(sorted_graph_users).map(&:user)

        {
          users: paginated_users.map{|u| KillObject.user u},
          total: sorted_graph_users.size
        }
      end

      def sorted_graph_users
        @sorted_graph_users ||= with_me_up_front(users_who(opinion))
      end

      def with_me_up_front list
        return list unless current_user

        where_i_am = list.index do |graph_user|
          graph_user.id == current_user.graph_user_id
        end

        if where_i_am
          me = list.slice!(where_i_am)
          list.unshift(me)
        else
          list
        end
      end

      def current_user
        @options[:current_user]
      end

      def paginate(data)
        data.drop(skip).take(take)
      end

      def users_who(opinion)
        Fact[fact_id].send("people_#{opinion}").to_a
      end
    end
  end
end
