module Interactors
  module Facts
    class Create
      include Pavlov::Interactor
      include Util::CanCan

      attribute :displaystring, String
      attribute :site_url, String
      attribute :site_title, String
      attribute :fact_id, String, default: nil
      attribute :group_id, Integer, default: nil
      attribute :pavlov_options, Hash

      def authorized?
        true
      end

      private

      def execute
        dead_fact = Backend::Facts.create(
            displaystring: displaystring,
            site_url: site_url, site_title: site_title, created_at: pavlov_options[:time],
            fact_id: (pavlov_options[:import] ? fact_id : nil),
            created_by_id: pavlov_options[:current_user].id,
            group_id: group_id
        )

        create_activity dead_fact
        dead_fact
      end

      def create_activity(dead_fact)
        Backend::Activities.create \
          user_id: pavlov_options[:current_user].id,
          action: :created_fact,
          subject: FactData.where(fact_id: dead_fact.id).first,
          time: pavlov_options[:time],
          send_mails: pavlov_options[:send_mails]
      end

      def validate
        validate_nonempty_string :displaystring, displaystring
        validate_string :site_title, site_title
        validate_string :site_url, site_url

        if pavlov_options[:import]
          validate_integer_string :fact_id, fact_id
        end
      end
    end
  end
end
