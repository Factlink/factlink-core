module Acceptance
  include PavlovSupport

  def sign_in_user(user)
    visit factlink_accounts_new_path
    fill_in "user_new_session[email]", with: user.email
    fill_in "user_new_session[password]", with: user.password
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

  def enable_global_features(*features)
    fail "FeatureNonExistent" unless features.all? { |f| Ability::FEATURES.include? f.to_s }

    as(create :user, :confirmed, :admin) do |pavlov|
      pavlov.interactor(:'global_features/set', features: features)
    end
  end

  def disable_html5_validations(page)
    page.execute_script "$('form').attr('novalidate','novalidate')"
  end

  def eventually_succeeds(wait_time=nil, &block)
    wait_time ||= Capybara.default_wait_time
    start_time = Time.now
    begin
      yield
    rescue => e
      if (Time.now - start_time) >= wait_time then
        raise e
      end
      sleep(0.05)
      retry
    end
  end

  def wait_for_ajax_idle
    eventually_succeeds do
      # wait for all ajax requests to complete
      # if we don't wait, the server may see it after the db is cleaned
      # and a request for a removed object will cause a crash (nil ref).
      unless page.evaluate_script('(!window.jQuery || window.jQuery.active == 0)')
        fail 'jQuery.active is not zero; did an Ajax callback perhaps crash?'
      end
    end
  end
end
