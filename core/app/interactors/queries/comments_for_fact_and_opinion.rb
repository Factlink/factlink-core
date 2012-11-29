require_relative '../pavlov'
require_relative '../kill_object'

module Queries
  class CommentsForFactAndOpinion
    include Pavlov::Query

    arguments :fact_id, :opinion

    def validate
      validate_integer :fact_id, @fact_id
      validate_in_set  :opinion, @opinion, ['believes', 'disbelieves', 'doubts']
    end

    def execute
      comments.map do |comment|
        comment.authority = query :authority_on_fact_for, fact, comment.created_by.graph_user

        KillObject.comment comment
      end
    end

    def comments
      fact_data_id = fact.data_id
      Comment.where({fact_data_id: fact_data_id, opinion: @opinion}).to_a
    end

    def fact
      @fact ||= Fact[@fact_id]
    end
  end
end
