module Interactors
  module Topics
    class Get
      include Pavlov::Interactor
      include Util::CanCan

      arguments :slug_title

      def execute
        DeadTopic.new topic.slug_title,
                      topic.title
      end

      def topic
        @topic ||= query :'topics/by_slug_title', slug_title: slug_title
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
