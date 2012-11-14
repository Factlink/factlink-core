module Queries
  class AuthorityOnTopicFor
    include Pavlov::Query

    arguments :topic, :graph_user

    def execute
      Authority.from(@topic , for: @graph_user).to_s.to_f + 1.0
    end
  end
end
