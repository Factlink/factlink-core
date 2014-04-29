require 'acceptance_helper'

describe 'Password recovery', type: :feature do

  before do
    @user = create :user, :confirmed
  end

  it 'informs the user the email has been send' do
    clear_emails

    visit new_user_password_path
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

    find('.notification-center-alert-container', text: 'Your password was changed successfully. You are now signed in.')
  end
end
