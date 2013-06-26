module Queries
  class AuthorityOnTopicFor
    include Pavlov::Query

    arguments :topic, :graph_user

    def execute
      authority + 1
    end

    def authority
      # TODO fix properly somewhere else, make sure this is a topic before here
      if topic
        Authority.from(topic , for: graph_user).to_f
      else
        0
      end
    end
  end
end
