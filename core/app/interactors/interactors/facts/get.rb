module Interactors
  module Facts
    class Get
      include Pavlov::Interactor
      include Util::CanCan

      arguments :id

      def execute
        add_to_recently_viewed

        Backend::Facts.get(fact_id: id)
      end

      def add_to_recently_viewed
        return unless pavlov_options[:current_user]

        Backend::Facts.add_to_recently_viewed \
          fact_id: id,
          user_id: pavlov_options[:current_user].id
      end

      def authorized?
        true
      end

      def validate
        validate_integer_string :id, id
      end
    end
  end
end
