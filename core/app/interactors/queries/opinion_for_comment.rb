require_relative '../pavlov'

module Queries
  class OpinionForComment
    include Pavlov::Query

    arguments :comment_id, :fact

    def validate
      validate_hexadecimal_string :comment_id, @comment_id
    end

    def execute
      calculator.opinion
    end

    def calculator
      UserOpinionCalculation.new believable, &authority_for
    end

    def authority_for
      Proc.new do |graph_user|
        Authority.on(@fact, for: graph_user).to_f + 1
      end
    end

    def believable
      Believable::Comment.new(@comment_id)
    end

  end
end
