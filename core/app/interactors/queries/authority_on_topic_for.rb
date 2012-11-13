module Queries
  class AuthorityOnTopicFor
    def initialize(slug_title, user, options={})
      @slug_title = slug_title
      @user = user
    end

    def execute
      topic = Topic.by_slug @slug_title

      Authority.from(topic , for: @user.graph_user).to_s.to_f + 1.0
    end
  end
end
