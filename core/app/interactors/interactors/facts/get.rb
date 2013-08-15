module Interactors
  module Facts
    class Get
      include Pavlov::Interactor
      include Util::CanCan

      arguments :id

      def execute
        add_to_recently_viewed

        query(:'facts/get', id: id)
      end

      def add_to_recently_viewed
        return unless pavlov_options[:current_user]

        command(:'facts/add_to_recently_viewed',
                    fact_id: id.to_i, user_id: pavlov_options[:current_user].id.to_s)
      end

      def authorized?
        can? :show, Fact
      end

      def validate
        validate_integer_string :id, id
      end
    end
  end
end
