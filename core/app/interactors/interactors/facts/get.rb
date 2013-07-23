module Interactors
  module Facts
    class Get
      include Pavlov::Interactor
      include Util::CanCan

      arguments :id

      def execute
        add_to_recently_viewed

        old_query :'facts/get', id
      end

      def add_to_recently_viewed
        return unless @options[:current_user]

        old_command :"facts/add_to_recently_viewed", id.to_i, @options[:current_user].id.to_s
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
