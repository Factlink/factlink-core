module Acceptance
  module ProfileHelper
    def go_to_profile_page_of user
      visit user_profile_path(user.username)
    end

    def check_follower_following_count number_of_following, number_of_followers
      page.should have_content "#{number_of_following} following"

      s = 's' unless number_of_followers == 1
      page.should have_content "#{number_of_followers} follower#{s}"
    end
  end
end
