module Interactors
  module Facts
    class Create
      include Pavlov::Interactor
      include Util::CanCan

      attribute :displaystring, String
      attribute :url, String
      attribute :site_title, String
      attribute :pavlov_options, Hash
      attribute :fact_id, String, default: nil

      def authorized?
        true
      end

      private

      def execute
        dead_fact = Backend::Facts.create displaystring: displaystring,
          url: url, site_title: site_title, fact_id: fact_id, created_at: pavlov_options[:time]

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

        unless fact_id.nil?
          validate_integer_string :fact_id, fact_id
        end
      end
    end
  end
end
