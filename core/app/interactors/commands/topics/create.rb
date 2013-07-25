require 'pavlov'

module Commands
  module Topics
    class Create
      include Pavlov::Command

      arguments :title
      attribute :pavlov_options, Hash, default: {}

      def execute
        topic = Topic.create title: title
        KillObject.topic topic
      end

      def validate
        validate_nonempty_string :title, @title
      end
    end
  end
end
