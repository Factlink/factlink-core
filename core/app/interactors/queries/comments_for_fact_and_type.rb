require_relative '../pavlov'
require_relative '../kill_object'
require_relative 'comments/common_functionality'

module Queries
  class CommentsForFactAndType
    include Pavlov::Query
    include Comments::CommonFunctionality

    arguments :fact_id, :type

    def validate
      validate_integer :fact_id, @fact_id
      validate_in_set  :type, @type, ['believes', 'disbelieves', 'doubts']
    end

    def execute
      comments.map {|comment| extended_comment comment, fact}
    end

    def comments
      fact_data_id = fact.data_id
      Comment.where({fact_data_id: fact_data_id, type: @type}).to_a
    end

    def fact
      @fact ||= Fact[@fact_id]
    end
  end
end
