module Interactors
  module Facts
    class Create
      include Pavlov::Interactor
      include Util::CanCan

      arguments :displaystring, :url, :title, :sharing_options

      def authorized?
        can? :create, Fact
      end

      private

      def execute
        fact = command :'facts/create', displaystring, title, user, site

        raise "Errors when saving fact: #{fact.errors.inspect}" if fact.errors.length > 0
        raise "Errors when saving fact.data" unless fact.data.persisted?

        command :"facts/add_to_recently_viewed", fact.id.to_i, user.id.to_s

        if can? :share, Fact
          command :"facts/share_new", fact.id.to_s, sharing_options
        end

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
        validate_nonempty_string :displaystring, displaystring
        validate_string :title, title
        validate_string :url, url
        validate_not_nil :sharing_options, sharing_options
      end
    end
  end
end
