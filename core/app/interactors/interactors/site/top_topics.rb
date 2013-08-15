module Interactors
  module Site
    class TopTopics
      include Pavlov::Interactor

      arguments :url, :nr

      def validate
        validate_string :url, url
        validate_integer :nr, nr
      end

      def execute
        return unless site
        query(:'site/top_topics', site_id: site.id.to_i, nr: nr)
      end

      def site
        @site ||= ::Site.find(url: url).first
      end

      def authorized?
        pavlov_options[:current_user]
      end
    end
  end
end
