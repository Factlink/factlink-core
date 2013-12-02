module Queries
  class AuthorityOnFactFor
    include Pavlov::Query

    arguments :fact, :graph_user

    def execute
      "1.0"
    end
  end
end
