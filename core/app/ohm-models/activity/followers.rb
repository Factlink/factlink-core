class Activity < OurOhm
  module Followers
    include Pavlov::Helpers

    def followers_for_fact fact
      Backend::Followers.followers_for_fact fact
    end

    def followers_for_sub_comment sub_comment
      Backend::Followers.followers_for_sub_comments([sub_comment])
    end

    def followers_for_comment comment
      Backend::Followers.followers_for_comments([comment])
    end

    def followers_for_graph_user graph_user_id
      Backend::Followers.followers_for_graph_user_id graph_user_id
    end
  end
end
