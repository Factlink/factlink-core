module Interactors
  module Topics
    class Favourite
      include Pavlov::Interactor
      include Util::CanCan

      arguments :user_name, :slug_title

      def authorized?
        pavlov_options[:current_user] and can? :edit_favourites, user
      end

      def user
        @user ||= query :user_by_username, username: user_name
      end

      def topic
        @topic ||= query :'topics/by_slug_title', slug_title: slug_title
      end

      def execute
        command :'topics/favourite', graph_user_id: user.graph_user_id, topic_id: topic.id.to_s
        nil
      end

      def validate
        validate_nonempty_string :user_name, user_name
        validate_nonempty_string :slug_title, slug_title
      end
    end
  end
end
