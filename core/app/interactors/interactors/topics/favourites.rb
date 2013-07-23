require 'pavlov'

module Interactors
  module Topics
    class Favourites
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
        @user ||= old_query :user_by_username, user_name
      end

      def favourite_topic_ids
        old_query :'topics/favourite_topic_ids', user.graph_user_id
      end

      def favourite_topics
        favourite_topic_ids.map do |topic_id|
          old_query :'topics/by_id', topic_id
        end
      end

      def execute
        favourite_topics.sort {|a,b| a.slug_title <=> b.slug_title}
      end
    end
  end
end
