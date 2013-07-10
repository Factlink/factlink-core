module Queries
  class AuthorityOnTopicFor
    include Pavlov::Query

    arguments :topic, :graph_user

    def execute
      authority + 1
    end

    def authority
      Authority.from(topic, for: graph_user).to_f
    end
  end
end
