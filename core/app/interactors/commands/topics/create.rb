module Commands
  module Topics
    class Create
      include Pavlov::Command

      arguments :title

      def execute
        topic = Topic.create title: title
        DeadTopic.new topic.slug_title, topic.title
      end
    end
  end
end
