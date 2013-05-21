module Acceptance
  module AuthenticationHelper
    def assert_on_login_page
      page.find('h2', text: 'Sign in to Factlink')
    end
  end
end
