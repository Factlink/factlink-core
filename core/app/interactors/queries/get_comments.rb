require_relative '../pavlov'
require_relative '../kill_object'

module Queries
  class GetComments
    include Pavlov::Query

    arguments :fact_id, :opinion

    def validate
      validate_integer :fact_id, @fact_id
      validate_in_set  :opinion, @opinion, ['believes', 'disbelieves', 'doubts']
    end

    def execute
      comments.map do |comment|
        # HACK: This shortcut of using `comment.fact_data.fact` instead of `comment` itself
        # is possible because in the current calculation these authorities are the same
        authority = Authority.on(comment.fact_data.fact, for: comment.created_by.graph_user)
        comment.authority = authority.to_s(1.0)

        KillObject.comment comment
      end
    end

    def comments
      fact_data_id = Fact[@fact_id].data_id
      Comment.where({fact_data_id: fact_data_id, opinion: @opinion}).to_a
    end
  end
end
