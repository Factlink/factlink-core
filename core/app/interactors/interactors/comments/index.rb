require_relative '../../pavlov'

module Interactors
  module Comments
    class Index
      include Pavlov::Interactor

      arguments :fact_id, :opinion

      def validate
        validate_integer :fact_id, @fact_id
        validate_in_set  :opinion, @opinion, ['believes', 'disbelieves', 'doubts']
      end

      def authorized?
        @options[:current_user]
      end

      def execute
        comments = query :comments_for_fact_and_opinion, @fact_id, @opinion
        comments.each do |comment|
          comment.opinion = query :opinion_for_comment, comment, fact
        end
        comments
      end

      def fact
        @fact ||= Fact[@fact_id]
      end
    end
  end
end
