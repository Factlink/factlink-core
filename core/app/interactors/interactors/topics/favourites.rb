module Interactors
  module Topics
    class Favourites
      include Pavlov::Interactor
      include Util::CanCan

      arguments :user_name

      def authorized?
        pavlov_options[:current_user] and can? :show_favourites, user
      end

      def validate
        validate_nonempty_string :user_name, user_name
      end

      def user
        @user ||= query :user_by_username, username: user_name
      end

      def favourite_topic_ids
        query :'topics/favourite_topic_ids', graph_user_id: user.graph_user_id
      end

      def favourite_topics
        favourite_topic_ids.map do |topic_id|
          query :'topics/by_id', id: topic_id
        end
      end

      def execute
        favourite_topics.sort_by(&:slug_title)
      end
    end
  end
end
