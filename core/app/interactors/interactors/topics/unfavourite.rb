require 'pavlov'

module Interactors
  module Topics
    class Unfavourite
      include Pavlov::Interactor

      arguments :user_name, :slug_title

      def authorized?
        (!! @options[:current_user]) and (@options[:current_user].username == user_name)
      end

      def execute
        user = query :user_by_username, user_name
        topic = query :'topics/by_slug_title', slug_title
        command :'topics/unfavourite', user.graph_user_id, topic.id
        nil
      end

      def validate
        validate_nonempty_string :user_name, user_name
        validate_nonempty_string :slug_title, slug_title
      end
    end
  end
end
