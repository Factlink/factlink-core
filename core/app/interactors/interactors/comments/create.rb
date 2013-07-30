require 'pavlov'

module Interactors
  module Comments
    class Create
      include Pavlov::Interactor

      arguments :fact_id, :type, :content

      def execute
        comment = old_command :create_comment, fact_id, type,
          @content, pavlov_options[:current_user].id.to_s

        old_command :'comments/set_opinion', comment.id.to_s, 'believes', pavlov_options[:current_user].graph_user

        create_activity comment

        old_query :'comments/add_authority_and_opinion_and_can_destroy', comment, fact
      end

      def authority_of comment
        old_query :authority_on_fact_for, fact, comment.created_by.graph_user
      end

      def opinion_of comment
        old_query :'opinions/user_opinion_for_comment', comment.id.to_s, fact
      end

      def fact
        Fact[fact_id]
      end

      def create_activity comment
        # TODO fix this ugly data access shit, need to think about where to kill objects, etc
        old_command :create_activity,
          pavlov_options[:current_user].graph_user, :created_comment,
          Comment.find(comment.id), comment.fact_data.fact
      end

      def authorized?
        pavlov_options[:current_user]
      end

      def validate
        validate_regex   :content, content, /\S/,
          "should not be empty."
        validate_integer :fact_id, fact_id
        validate_in_set  :type, type, ['believes', 'disbelieves', 'doubts']
      end
    end
  end
end
