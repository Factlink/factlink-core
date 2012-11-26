module Acceptance
  def int_user
    user = FactoryGirl.create(:user)
    user.confirm!
    user
  end

  def handle_js_confirm(accept=true)
    page.evaluate_script "window.original_confirm_function = window.confirm"
    page.evaluate_script "window.confirm = function(msg) { return #{!!accept}; }"
    yield
    page.evaluate_script "window.confirm = window.original_confirm_function"
  end

  def create_admin_and_login
    admin = FactoryGirl.create(:admin_user)
    sign_in_user admin
  end

  def make_non_tos_user_and_login
    user = FactoryGirl.create(:approved_confirmed_user, agrees_tos: false)
    sign_in_user(user)
  end

  def sign_in_user(user)
    visit "/"
    click_link "Sign in"
    fill_in "user_login", :with => user.email
    fill_in "user_password", :with => user.password
    click_button "Sign in"

    user
  end

  def switch_to_user(user)
    sign_out_user
    sign_in_user(user)
  end

  def sign_out_user
    visit "/users/sign_out"
  end

  def random_username
    @username_sequence ||= FactoryGirl::Sequence.new :username do |n|
      "janedoe#{n}"
    end

    @username_sequence.next
  end

  def random_email
    @email_sequence ||= FactoryGirl::Sequence.new :email do |n|
      "janedoe#{n}@example.com"
    end

    @email_sequence.next
  end

  def enable_features(user, *features)
    raise "FeatureNonExistent" unless features.all? { |f| Ability::FEATURES.include? f.to_s }

    user.features = features
  end

  def wait_for_ajax
    begin
      wait_until { page.evaluate_script('jQuery.active') > 0 }
    rescue Capybara::TimeoutError
      puts 'No Ajax request was made, what are you waiting for?'
    end
    wait_until { page.evaluate_script('jQuery.active') == 0 }
  rescue Capybara::TimeoutError
    flunk 'The Ajax request was not ready in time'
  end

  def wait_until_scope_exists(scope, &block)
    wait_until { page.has_css?(scope) }
    within(scope, &block) if block_given?
  rescue Capybara::TimeoutError
    flunk "Expected '#{scope}' to be present."
  end

  def disable_html5_validations(page)
    page.execute_script "$('form').attr('novalidate','novalidate')"
  end
end
require_relative 'acceptance/discussion_page'
