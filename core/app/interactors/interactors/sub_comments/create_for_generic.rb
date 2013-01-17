require 'pavlov'

module Interactors
  module SubComments
    class CreateForGeneric
      include Pavlov::Interactor

      def authorized?
        @options[:current_user]
      end

      def execute
        raise Pavlov::ValidationError, "parent does not exist any more" unless parent

        sub_comment = create_sub_comment

        create_activity sub_comment

        KillObject.sub_comment sub_comment,
          authority: authority_of_user_who_created(sub_comment)
      end

      def create_activity sub_comment
        command :create_activity,
          @options[:current_user].graph_user, :created_sub_comment,
          sub_comment, top_fact
      end

      def authority_of_user_who_created sub_comment
        query :authority_on_fact_for, top_fact, sub_comment.created_by.graph_user
      end
    end
  end
end
