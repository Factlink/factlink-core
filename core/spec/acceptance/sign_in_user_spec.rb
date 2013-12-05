require 'acceptance_helper'

describe 'When a user signs in', type: :feature do
  it 'redirects to set up page for new users' do
    user = create :user

    sign_in_user(user)

    page.should have_content "set up your account here"
  end

  it 'he should be able to sign out' do
    user = create :full_user, :confirmed

    sign_in_user(user)

    page.should_not have_content "Your login credentials were incorrect. Please check and try again"

    visit '/users/sign_out'

    visit '/'

    page.should have_content 'Connect now'
  end

  it 'he should not be able to sign in with false credentials' do
    user = create :full_user, :confirmed

    visit factlink_accounts_new_path
    fill_in "user_new_session[login]", with: user.email
    fill_in "user_new_session[password]", with: user.password + '1'
    click_button "Sign in"

    page.should have_content 'incorrect email address or password'
  end
end
