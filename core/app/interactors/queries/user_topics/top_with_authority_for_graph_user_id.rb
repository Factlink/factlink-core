module Queries
  module UserTopics
    class TopWithAuthorityForGraphUserId
      include Pavlov::Query

      arguments :graph_user_id, :limit_topics

      def execute
        sorted_user_topics.take(limit_topics)
      end

      def sorted_user_topics
        user_topics.sort do |a,b|
          - (a.authority <=> b.authority)
        end
      end

      def user_topics
        topics.map do |topic|
          DeadUserTopic.new topic.slug_title,
                            topic.title,
                            authority_for(topic)
        end
      end

      def authority_for topic
        query :authority_on_topic_for, topic, graph_user
      end

      def hard_coded_topic_slugs_for_graphuser_id id
        user_hash = {
          17 => :Jens,
          46 => :martijn,
          2 => :tomdev,
          23 => :Vikingmobile,
          1 => :merijn,
          20 => :jobert,
          27 => :janpaul,
          6 => :mark,
          59 => :melvin,
          9 => :michiel,
          4 => :RSO,
          170 => :lbekkema,
          466 => :Nathan,
          166 => :JJoos,
          935 => :EamonNerbonne,
          227 => :annie
        }

        topic_hash = {
          :Jens=>["startups", "security"],
          :martijn=>["apple", "pinterest"],
          :tomdev=>["apple", "health"],
          :Vikingmobile=>["sustainability", "energy"],
          :merijn=>["apple", "startups"],
          :jobert=>["security", "programming"],
          :janpaul=>["education", "startups"],
          :mark=>["security", "programming"],
          :melvin=>["security", "development"],
          :michiel=>["programming", "security"],
          :RSO=>["coding", "server-management"],
          :lbekkema=>["growth-hacking", "ux-slash-ui"],
          :Nathan=>["apple", "ui-design"],
          :JJoos=>["big-data", "software-development"],
          :EamonNerbonne=>["big-data", "health"],
          :annie=>["sleep", "factlink"]
        }

        topic_hash.fetch(user_hash[id.to_i]) { :no_topic_slugs_for_graph_user }
      end

      def hardcoded_topics
        topic_slugs = hard_coded_topic_slugs_for_graphuser_id(graph_user_id)
        return :no_hardcoded_topics if topic_slugs == :no_topic_slugs_for_graph_user

        topic_slugs.map do |slug|
          query :'topics/by_slug_title', slug
        end.compact
      end

      def topics
        predefined_topics = hardcoded_topics
        return predefined_topics unless predefined_topics == :no_hardcoded_topics

        query :'topics/posted_to_by_graph_user', graph_user
      end

      def graph_user
        @graph_user ||= GraphUser[graph_user_id]
      end
    end
  end
end
