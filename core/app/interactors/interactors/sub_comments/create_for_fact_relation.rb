require 'pavlov'
require_relative 'create_for_generic'

module Interactors
  module SubComments
    class CreateForFactRelation < CreateForGeneric
      include Pavlov::Interactor

      arguments :fact_relation_id, :content

      def validate
        validate_integer :fact_relation_id, @fact_relation_id
        validate_regex   :content, @content, /\A(?=.*\S).+\Z/,
          "should not be empty."
      end

      def parent
        fact_relation
      end

      def create_sub_comment
        command :'sub_comments/create_xxx', @fact_relation_id, 'FactRelation', @content, @options[:current_user]
      end

      def top_fact
        @top_fact ||= fact_relation.fact
      end

      def fact_relation
        @fact_relation ||= FactRelation[@fact_relation_id]
      end
    end
  end
end
