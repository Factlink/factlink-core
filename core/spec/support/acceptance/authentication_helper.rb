module Acceptance
  module AuthenticationHelper
    def assert_on_login_page
      page.find('h2', text: 'Sign in to Factlink')
      page.find('input.btn', text: 'Sign In')
    end
  end
end
