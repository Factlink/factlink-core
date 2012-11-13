module Queries
  class AuthorityOnTopicFor
    def initialize(topic, user, options={})
      @topic = topic
      @user = user
    end

    def execute


      Authority.from(@topic , for: @user.graph_user).to_s.to_f + 1.0
    end
  end
end
