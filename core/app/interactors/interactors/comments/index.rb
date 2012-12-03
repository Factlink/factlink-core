require_relative '../../pavlov'

module Interactors
  module Comments
    class Index
      include Pavlov::Interactor

      # TODO-0312 rename opinion to type
      arguments :fact_id, :opinion

      def validate
        validate_integer :fact_id, @fact_id
        validate_in_set  :opinion, @opinion, ['believes', 'disbelieves', 'doubts']
      end

      def authorized?
        @options[:current_user]
      end

      def execute
        query :comments_for_fact_and_type, @fact_id, @opinion
      end

      def fact
        @fact ||= Fact[@fact_id]
      end
    end
  end
end
