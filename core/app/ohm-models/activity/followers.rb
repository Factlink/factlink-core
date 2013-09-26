class Activity < OurOhm
  module Followers
    include Pavlov::Helpers

    def followers_for_fact fact
      query(:'activities/graph_user_ids_following_fact', fact: fact)
    end

    def followers_for_sub_comment sub_comment
        if sub_comment.parent_class == 'Comment'
          followers_for_comment sub_comment.parent
        else
          followers_for_fact_relation sub_comment.parent
        end
    end

    def followers_for_comment comment
      query(:'activities/graph_user_ids_following_comments', comments: [comment])
    end

    def followers_for_fact_relation fact_relation
      query(:'activities/graph_user_ids_following_fact_relations', fact_relations: [fact_relation])
    end

    def followers_for_conversation conversation
      conversation.recipients.map { |r| r.graph_user.id }
    end

    def followers_for_graph_user graph_user_id
      query(:'users/follower_graph_user_ids', graph_user_id: graph_user_id)
    end

    def channel_followers_of_graph_user graph_user
      ChannelList.new(graph_user).channels
        .map { |channel| channel.containing_channels.to_a }
        .flatten
        .map(&:created_by_id).uniq
    end
  end
end
