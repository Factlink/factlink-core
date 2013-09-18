module Queries
  class UsersByIds
    include Pavlov::Query

    arguments :user_ids

    private

    def validate
      @user_ids.each { |id| validate_hexadecimal_string :id, id.to_s }
    end

    def execute
      users = User.any_in(_id: @user_ids)
      users.map{|user| kill user}
    end

    def kill user
      KillObject.user user,
        statistics: statistics(user.graph_user)
    end

    def statistics graph_user
      {
        # TODO: more efficient fact count
        created_fact_count: graph_user.created_facts_channel.sorted_cached_facts.size,
        follower_count: query(:'users/follower_count', graph_user_id: graph_user.id),
        following_count: query(:'users/following_count', graph_user_id: graph_user.id)
      }
    end
  end
end
