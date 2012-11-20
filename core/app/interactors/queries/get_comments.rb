require_relative '../pavlov'

module Queries
  class GetComments
    include Pavlov::Query

    arguments :fact_id, :opinion

    def validate
      validate_hexadecimal_string :fact_id, @fact_id
      validate_in_set  :opinion, @opinion, ['believes', 'disbelieves', 'doubts']
    end

    def execute
      Comment.find({fact_data_id: @fact_id, opinion: @opinion})
    end
  end
end
