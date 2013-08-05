class Activity < OurOhm
  module Followers
    include Pavlov::Helpers

    def followers_for_fact fact
      old_query :'activities/graph_user_ids_following_fact', fact
    end

    def followers_for_sub_comment sub_comment
        if sub_comment.parent_class == 'Comment'
          followers_for_comment sub_comment.parent
        else
          followers_for_fact_relation sub_comment.parent
        end
    end

    def followers_for_comment comment
      old_query :'activities/graph_user_ids_following_comments', [comment]
    end

    def followers_for_fact_relation fact_relation
      old_query :'activities/graph_user_ids_following_fact_relations', [fact_relation]
    end

    def followers_for_conversation conversation
      conversation.recipients.map { |r| r.graph_user.id }
    end

    def followers_for_graph_user graph_user_id
      old_query :'users/follower_graph_user_ids', graph_user_id
    end

    def channel_followers_of_graph_user graph_user
      ChannelList.new(graph_user).channels
        .map { |channel| channel.containing_channels.to_a }
        .flatten
        .map(&:created_by_id).uniq
    end

    def channel_followers_of_graph_user_minus_regular_followers graph_user
      channel_followers_of_graph_user(graph_user) - followers_for_graph_user(graph_user.id)
    end
  end
end
