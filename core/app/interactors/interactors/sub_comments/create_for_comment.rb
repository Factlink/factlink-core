require 'pavlov'
require_relative 'create_for_generic'

module Interactors
  module SubComments
    class CreateForComment < CreateForGeneric
      include Pavlov::Interactor

      arguments :comment_id, :content

      def validate
        validate_hexadecimal_string :comment_id, @comment_id
        validate_regex   :content, @content, /\A(?=.*\S).+\Z/,
          "should not be empty."
      end

      def create_sub_comment
        command :'sub_comments/create_xxx', @comment_id, 'Comment', @content, @options[:current_user]
      end

      def top_fact
        @top_fact ||= Comment.find(@comment_id).fact_data.fact
      end
    end
  end
end
