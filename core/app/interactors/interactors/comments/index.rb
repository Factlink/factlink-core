require_relative '../../pavlov'

module Interactors
  module Comments
    class Index
      include Pavlov::Interactor

      arguments :fact_id, :type

      def validate
        validate_integer :fact_id, @fact_id
        validate_in_set  :type,    @type, ['believes', 'disbelieves', 'doubts']
      end

      def authorized?
        @options[:current_user]
      end

      def execute
        query :comments_for_fact_and_type, @fact_id, @type
      end

      def fact
        @fact ||= Fact[@fact_id]
      end
    end
  end
end

