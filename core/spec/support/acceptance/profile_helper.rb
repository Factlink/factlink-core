module Acceptance
  module ProfileHelper
    def go_to_profile_page_of user
      visit user_profile_path(user)
    end

    def check_follower_following_count number_of_following, number_of_followers
      all_social_statistics = page.all(:css, 'div.social-statistic-block')
      all_social_statistics[0].should have_content "#{number_of_following} following"

      s = 's' unless number_of_followers == 1
      all_social_statistics[1].should have_content "#{number_of_followers} follower#{s}"
    end
  end
end
