module Interactors
  module SubComments
    class Destroy
      include Pavlov::Interactor
      include Util::CanCan

      arguments :id

      def validate
        validate_integer_string :id, id
      end

      def authorized?
        sub_comment = SubComment.find(id)

        can? :destroy, sub_comment
      end

      def execute
        Backend::SubComments.destroy! id: id
      end
    end
  end
end
