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
    end

    def execute
      User.any_in(by => user_ids).map do |user|
        KillObject.user user,
          statistics: statistics(user.graph_user_id)
      end
    end

    def statistics graph_user_id
      {
        created_fact_count: GraphUser.key[graph_user_id][:sorted_created_facts].zcard,
        follower_count: UserFollowingUsers.new(graph_user_id).followers_count,
        following_count: UserFollowingUsers.new(graph_user_id).following_count
      }
    end
  end
end
