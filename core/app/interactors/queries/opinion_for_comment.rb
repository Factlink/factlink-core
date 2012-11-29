require_relative '../pavlov'

module Queries
  class OpinionForComment
    include Pavlov::Query

    arguments :comment_id, :fact

    def execute
      Opinion.new
    end

    def validate
      validate_hexadecimal_string :comment_id, @comment_id
    end

  end
end
