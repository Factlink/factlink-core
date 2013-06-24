module Interactors
  module Facts
    class Create
      include Pavlov::Interactor

      arguments :displaystring, :url, :title

      def authorized?
        user
      end

      private

      def execute
        fact = command :'facts/create', displaystring, title, user, site

        raise "Errors when saving fact: #{fact.errors.inspect}" if fact.errors.length > 0
        raise "Errors when saving fact.data" unless fact.data.persisted?

        command :"facts/add_to_recently_viewed", fact.id.to_i, user.id.to_s
        fact
      end

      def site
        return nil if url.blank?

        site = query :'sites/for_url', url

        if site.nil?
          command :'sites/create', url
        else
          site
        end
      end

      def user
        @options[:current_user]
      end

      def validate
        validate_string :title, title
        validate_string :url, url
        validate_nonempty_string :displaystring, displaystring
      end
    end
  end
end
