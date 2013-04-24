require 'pavlov'

module Interactors
  module Topics
    class FavouriteTopics
      include Pavlov::Interactor
      include Util::CanCan

      arguments :user_name

      def authorized?
        @options[:current_user] and can? :show_favourites, user
      end

      def validate
        validate_nonempty_string :user_name, @user_name
      end

      def user
        @user ||= query :user_by_username, user_name
      end

      def favourite_topic_ids
        query :'topics/favourite_topic_ids', user.graph_user_id
      end

      def execute
        favourite_topic_ids.map do |topic_id|
          query :'topics/by_id', topic_id
        end
      end
    end
  end
end
