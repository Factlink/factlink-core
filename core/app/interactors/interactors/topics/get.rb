module Interactors
  module Topics
    class Get
      include Pavlov::Interactor
      include Util::CanCan

      arguments :slug_title

      def execute
        DeadTopic.new topic.slug_title,
                      topic.title,
                      authority
      end

      def topic
        @topic ||= query :'topics/by_slug_title', slug_title: slug_title
      end

      def authority
        return nil unless pavlov_options[:current_user]

        graph_user = pavlov_options[:current_user].graph_user
        query :authority_on_topic_for, topic: topic, graph_user: graph_user
      end

      def validate
        validate_string :slug_title, slug_title
      end

      def authorized?
        can? :show, topic
      end
    end
  end
end
