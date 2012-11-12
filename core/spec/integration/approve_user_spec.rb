require 'integration_helper'

describe 'When a User gets approved', type: :request do
  pending 'the User should get notified through email' do
    clear_emails

    user = FactoryGirl.create :user, agrees_tos: false

    # We approve the user manually because the button on the /a/users/reserved URL
    # works with a PUT request, which is not supported by Capybara::Webkit
    # (see https://github.com/thoughtbot/capybara-webkit/issues/180)
    user.approved = true
    user.save

    open_email(user.email)

    current_email.click_link 'Click here to start using Factlink'

    # From here it's basically a "First step of sign up process (set passwords) should work"
    page.should have_content 'Set up your Factlink account'

    old_url = current_url

    fill_in 'user_password', with: "our_house"
    fill_in 'user_password_confirmation', with: "our_house"

    click_button "Next Step"

    current_url.should_not equal old_url
  end
end
