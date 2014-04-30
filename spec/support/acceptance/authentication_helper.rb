module Acceptance
  module AuthenticationHelper
    def assert_on_login_page
      page.find('h2', text: 'Sign in to ' + I18n.t(:app_name))
    end
  end
end
