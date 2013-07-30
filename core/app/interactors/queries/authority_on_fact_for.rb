require 'pavlov'

module Queries
  class AuthorityOnFactFor
    include Pavlov::Query

    arguments :fact, :graph_user

    def execute
      authority = Authority.on(@fact, for: @graph_user)
      authority.to_s(1.0)
    end
  end
end
