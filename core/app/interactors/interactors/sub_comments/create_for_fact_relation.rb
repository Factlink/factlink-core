require 'pavlov'
require_relative 'create_for_generic'

module Interactors
  module SubComments
    class CreateForFactRelation < CreateForGeneric
      include Pavlov::Interactor

      arguments :fact_relation_id, :content, :pavlov_options

      def validate
        validate_integer :fact_relation_id, fact_relation_id
        validate_regex   :content, content, /\S/,
          "should not be empty."
      end

      def parent
        fact_relation
      end

      def create_sub_comment
        old_command :'sub_comments/create_xxx', fact_relation_id, 'FactRelation', content, pavlov_options[:current_user]
      end

      def top_fact
        @top_fact ||= fact_relation.fact
      end

      def fact_relation
        @fact_relation ||= FactRelation[fact_relation_id]
      end
    end
  end
end
