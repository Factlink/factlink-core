require 'pavlov'

module Interactors
  module SubComments
    class Destroy
      include Pavlov::Interactor
      include Util::CanCan

      arguments :id

      def validate
        validate_hexadecimal_string :id, id
      end

      def authorized?
        sub_comment = SubComment.find(id)

        can? :destroy, sub_comment
      end

      def execute
        command :'sub_comments/destroy', id
      end

    end
  end
end
