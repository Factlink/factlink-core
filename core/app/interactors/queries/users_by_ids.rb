module Queries
  class UsersByIds
    include Pavlov::Query

    attribute :user_ids, Array
    attribute :top_topics_limit, Integer, default: 1

    private

    def validate
      @user_ids.each { |id| validate_hexadecimal_string :id, id.to_s }
    end

    def execute
      users = User.any_in(_id: @user_ids)
      users.map{|user| kill user}
    end

    def kill user
      graph_user = user.graph_user
      KillObject.user user,
        statistics: statistics(graph_user),
        top_user_topics: top_user_topics(graph_user)
    end

    def statistics graph_user
      {
        # TODO: more efficient fact count
        created_fact_count: graph_user.created_facts_channel.sorted_cached_facts.size,
      }
    end

    def top_user_topics graph_user
      query(:'user_topics/top_with_authority_for_graph_user_id',
                graph_user_id: graph_user.id, limit_topics: top_topics_limit)
    end
  end
end
