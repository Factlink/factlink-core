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
      fact_data_id = Fact[@fact_id].data_id
      comments = Comment.where({fact_data_id: fact_data_id, opinion: @opinion}).to_a

      comments.map do |comment|
        KillObject.comment comment
      end
    end
  end
end
