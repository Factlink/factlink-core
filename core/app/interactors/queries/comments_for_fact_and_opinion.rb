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
        comment.authority = query :authority_of_created_user_for_comment, comment.id.to_s

        KillObject.comment comment
      end
    end

    def comments
      fact_data_id = Fact[@fact_id].data_id
      Comment.where({fact_data_id: fact_data_id, opinion: @opinion}).to_a
    end
  end
end
