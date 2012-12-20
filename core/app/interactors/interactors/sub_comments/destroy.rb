require_relative '../../pavlov'

module Interactors
  module SubComments
    class Destroy
      include Pavlov::Interactor

      arguments :id

      def validate
        validate_hexadecimal_string :id, @id
      end

      def authorized?
        @options[:current_user]
      end

      def execute
        raise_unauthorized unless i_own_sub_comment
        command :'sub_comments/destroy', @id
      end

      def i_own_sub_comment
        comment.created_by_id == current_user.id
      end

      def comment
        query :'sub_comments/get', @id
      end

      def current_user
        @options[:current_user]
      end
    end
  end
end
