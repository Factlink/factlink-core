module Interactors
  module SubComments
    class CreateForGeneric
      include Pavlov::Interactor
      include Util::CanCan

      def authorized?
        can?(:show, parent) and
          can?(:create, SubComment)
      end

      def execute
        raise Pavlov::ValidationError, "parent does not exist any more" unless parent

        sub_comment = create_sub_comment

        create_activity sub_comment

        KillObject.sub_comment sub_comment
      end

      def create_activity sub_comment
        command(:'create_activity',
                    graph_user: pavlov_options[:current_user].graph_user,
                    action: :created_sub_comment, subject: sub_comment,
                    object: top_fact)
      end
    end
  end
end
