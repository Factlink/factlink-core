require 'acceptance_helper'

describe 'Password recovery', type: :feature do

  before do
    @user = create :full_user, :confirmed
  end

  it 'informs the user the email has been send' do
    clear_emails

    @user.username = "Barones"

    visit "/"
    first(:link, "Sign in", exact: true).click
    click_link "Forgot password?"

    fill_in 'user_email', with: @user.email
    click_button "Send me reset password instructions"
    page.should have_content("You will receive an email with instructions about how to reset your password in a few minutes")

    open_email(@user.email)
    current_email.should have_content('Reset password')

    @user.reload

    visit edit_user_password_path(reset_password_token: @user.reset_password_token)

    fill_in "user_password", with: "our_house"
    fill_in "user_password_confirmation", with: "our_house"
    click_button "Change my password"

    page.should have_content("Your password was changed successfully. You are now signed in.")
  end
end
