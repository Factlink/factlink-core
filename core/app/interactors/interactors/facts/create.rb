module Interactors
  module Facts
    class Create
      include Pavlov::Interactor
      include Util::CanCan

      attribute :displaystring, String
      attribute :site_url, String
      attribute :site_title, String
      attribute :fact_id, String, default: nil
      attribute :pavlov_options, Hash

      def authorized?
        true
      end

      private

      def execute
        Backend::Facts.create displaystring: displaystring,
          site_url: site_url, site_title: site_title, created_at: pavlov_options[:time],
          fact_id: (pavlov_options[:import] ? fact_id : nil)

        create_activity dead_fact
      end

      def create_activity(dead_fact)
        Backend::Activities.create \
          graph_user_id: pavlov_options[:current_user].graph_user_id,
          action: :created_fact,
          subject_id: dead_fact.id,
          subject_class: "FactData",
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
