# This query returns dead user objects, retrieved by their ids
# You have the option to call it with mongo ids, or with (Ohm) GraphUser
# ids.
# Please try to avoid to add support for all other kinds of fields,
# both because we want it to have an index, and because we don't want to
# leak too much of the internals
module Queries
  class UsersByIds
    include Pavlov::Query

    attribute :user_ids, Array
    attribute :top_topics_limit, Integer, default: 1
    attribute :by, Symbol, default: :_id

    private

    def validate
      validate_in_set :by, by, [:_id, :graph_user_id]
      user_ids.each { |id| validate_hexadecimal_string :id, id.to_s }
    end

    def execute
      users = User.any_in(by => user_ids)
      users.map { |user| kill user }
    end

    def kill user
      graph_user = user.graph_user
      KillObject.user user,
        statistics: statistics(graph_user),
        top_user_topics: top_user_topics(user.id)
    end

    def statistics graph_user
      {
        created_fact_count: graph_user.created_facts.size,
        follower_count: query(:'users/follower_count', graph_user_id: graph_user.id),
        following_count: query(:'users/following_count', graph_user_id: graph_user.id)
      }
    end

    def top_user_topics user_id
      query(:'user_topics/top_with_authority_for_user',
            user_id: user_id.to_s, limit_topics: top_topics_limit)
    end
  end
end
