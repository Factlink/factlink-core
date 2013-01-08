require 'pavlov'
require_relative '../kill_object'
require 'andand'

module Queries
  class FactInteractingUsers
    include Pavlov::Query

    arguments :fact_id, :skip, :take, :opinion

    def validate
      validate_integer :fact_id, @fact_id
      validate_integer :skip,    @skip
      validate_integer :take,    @take
      validate_in_set  :opinion, @opinion, ['believes','disbelieves','doubts']
    end

    def execute
      graph_users= users_who(@opinion)
      paginated_users = paginate(graph_users).map {|gu| gu.user}

      {
        users: paginated_users.map{|u| KillObject.user u},
        total: graph_users.size
      }
    end

    def paginate(data)
      data.drop(@skip).take(@take)
    end

    def users_who(opinion)
      Fact[@fact_id].send("people_#{opinion}").to_a
    end
  end
end
