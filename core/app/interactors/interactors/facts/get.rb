module Interactors
  module Facts
    class Get
      include Pavlov::Interactor
      include Util::CanCan

      arguments :id

      def execute
        add_to_recently_viewed

        fact_with_evidence_count
      end

      def fact_with_evidence_count
        fact = query :'facts/get', id
        fact.evidence_count = query :'evidence/count_for_fact', fact
        fact
      end

      def add_to_recently_viewed
        return unless @options[:current_user]

        command :"facts/add_to_recently_viewed", id.to_i, @options[:current_user].id.to_s
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
