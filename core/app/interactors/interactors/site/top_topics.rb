module Interactors
  module Site
    class TopTopics
      include Pavlov::Interactor

      arguments :url, :nr

      def validate
        validate_string :url, @url
        validate_integer :nr, @nr
      end

      def execute
        query :"site/top_topics", site.id.to_i, @nr if site
      end

      def site
        @site ||= ::Site.find(url: @url).first
      end

      def authorized?
        @options[:current_user]
      end
    end
  end
end
