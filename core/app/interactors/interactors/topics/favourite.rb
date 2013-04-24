require 'pavlov'

module Interactors
  module Topics
    class Favourite
      include Pavlov::Interactor
      include Util::CanCan

      arguments :user_name, :slug_title

      def authorized?
        @options[:current_user] and can? :edit_favourites, user
      end

      def user
        @user ||= query :user_by_username, user_name
      end

      def execute
        topic = query :'topics/by_slug_title', slug_title
        command :'topics/favourite', user.graph_user_id, topic.id
        nil
      end

      def validate
        validate_nonempty_string :user_name, user_name
        validate_nonempty_string :slug_title, slug_title
      end
    end
  end
end
