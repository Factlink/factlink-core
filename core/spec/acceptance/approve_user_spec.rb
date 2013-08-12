require 'acceptance_helper'

describe 'When a User gets approved', type: :feature do
  it 'the User should get notified through email' do
    clear_emails

    user = create :user, agrees_tos: false

    # We approve the user manually because the button on the /a/users/reserved URL
    # works with a PUT request, which is not supported by Capybara::Webkit
    # (see https://github.com/thoughtbot/capybara-webkit/issues/180)
    user.approved = true
    user.save

    open_email(user.email)

    link = current_email.find_link 'Start using Factlink now'

    visit link[:href]

    # From here it's basically a "First step of sign up process (set passwords) should work"
    page.should have_content 'set up your account here:'

    old_url = current_url

    fill_in 'user_password', with: "our_house"
    fill_in 'user_password_confirmation', with: "our_house"

    click_button "Next Step"

    current_url.should_not equal old_url
  end

  it 'shows "account already set up" message when reset token is invalid' do
    user = create :user

    visit edit_user_password_path(msg: 'hoi', reset_password_token: 'doei')

    page.should have_content 'Your account is already set up. Please log in to continue.'
  end
end
