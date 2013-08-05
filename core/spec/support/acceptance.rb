module Acceptance
  def int_user
    user = create(:user)
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
    admin = create(:admin_user)
    sign_in_user admin
  end

  def make_non_tos_user_and_login
    user = create(:approved_confirmed_user, agrees_tos: false)
    sign_in_user(user)
  end

  def sign_in_user(user)
    visit "/"
    first(:link, "Sign in", exact: true).click
    fill_in "user_login", :with => user.email
    fill_in "user_password", :with => user.password
    click_button "Sign in"

    @current_user = user

    user
  end

  def switch_to_user(user)
    sign_out_user
    sign_in_user(user)
  end

  def sign_out_user
    @current_user = nil
    visit "/users/sign_out"
  end

  def use_features *new_features
    features = @current_user.features.to_a + new_features
    @current_user.features = features
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

  def disable_html5_validations(page)
    page.execute_script "$('form').attr('novalidate','novalidate')"
  end

  def eventually_succeeds(&block)
    start_time = Time.now
    begin
      yield
    rescue => e
      if (Time.now - start_time) >= Capybara.default_wait_time ||
          !page.driver.wait? then
        raise e
      end
      sleep(0.05)
      retry
    end
  end
end
