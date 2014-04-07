module Interactors
  module Facts
    class Create
      include Pavlov::Interactor
      include Util::CanCan

      arguments :displaystring, :url, :site_title

      def authorized?
        true
      end

      private

      def execute
        dead_fact = Backend::Facts.create displaystring: displaystring,
          url: url, site_title: site_title

        if user
          Backend::Facts.add_to_recently_viewed \
            fact_id: dead_fact.id,
            user_id: user.id
        end

        dead_fact
      end

      def user
        pavlov_options[:current_user]
      end

      def validate
        validate_nonempty_string :displaystring, displaystring
        validate_string :site_title, site_title
        validate_string :url, url
      end
    end
  end
end
