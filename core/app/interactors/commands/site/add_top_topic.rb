require_relative './common_functionality.rb'

module Commands
  module Site
    class AddTopTopic
      include Pavlov::Command
      include CommonFunctionality

      arguments :site_id, :topic_slug

      def execute
        increase_topic_by @topic_slug, 1
      end

      def validate
        validate_integer :site_id, @site_id
        validate_string :topic_slug, @topic_slug
      end
    end
  end
end
