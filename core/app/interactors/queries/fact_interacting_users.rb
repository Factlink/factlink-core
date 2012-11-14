require_relative '../pavlov'
require_relative '../kill_object'
require 'hashie'
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
      data = Fact[@fact_id].interactions.below('inf', reversed: true).select {|i| i.action == @opinion}.uniq{|i| i.user}
      users = data.drop(@skip).take(@take).map {|i| i.user.user}
      total = data.size

      users.map{|u| KillObject.user u}

      {users: users, total: total}
    end

    def authorized?
      true
    end
  end
end
