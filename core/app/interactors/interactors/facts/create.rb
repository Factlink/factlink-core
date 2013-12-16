module Interactors
  module Facts
    class Create
      include Pavlov::Interactor
      include Util::CanCan

      arguments :displaystring, :url, :title

      def authorized?
        can? :create, Fact
      end

      private

      def execute
        fact = command(:'facts/create',
                          displaystring: displaystring, title: title,
                          creator: user, site: site)

        fail "Errors when saving fact: #{fact.errors.inspect}" if fact.errors.length > 0
        fail "Errors when saving fact.data" unless fact.data.persisted?

        command(:'facts/add_to_recently_viewed',
                    fact_id: fact.id.to_i, user_id: user.id.to_s)

        fact
      end

      def site
        return nil if url.blank?
        return nil if Blacklist.default.matches? url

        site = query(:'sites/for_url', url: url)

        if site.nil?
          command(:'sites/create', url: url)
        else
          site
        end
      end

      def user
        pavlov_options[:current_user]
      end

      def validate
        validate_nonempty_string :displaystring, displaystring
        validate_string :title, title
        validate_string :url, url
      end
    end
  end
end
