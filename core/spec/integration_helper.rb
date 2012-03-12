require 'capybara/rspec'

Capybara.javascript_driver = :webkit

def int_user
  user = Factory.create(:user, email: "user@example.com")
  user.confirm!
  user
end

def handle_js_confirm(accept=true)
  page.evaluate_script "window.original_confirm_function = window.confirm"
  page.evaluate_script "window.confirm = function(msg) { return #{!!accept}; }"
  yield
  page.evaluate_script "window.confirm = window.original_confirm_function"
end