module Acceptance
  module ProfileHelper
    def go_to_profile_page_of user
      visit user_profile_path(user)
    end
  end
end
