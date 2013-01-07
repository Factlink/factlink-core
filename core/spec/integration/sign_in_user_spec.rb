require 'integration_helper'

describe 'When a user signs in', type: :request do
  it 'and has not yet confirmed his email address it should fail' do
    user = FactoryGirl.create :user

    sign_in_user(user)

    page.should have_content "Your account has not yet been approved"
  end

  it 'he should be able to sign out' do
    user = FactoryGirl.create :active_user

    sign_in_user(user)

    page.should_not have_content "Your login credentials were incorrect. Please check and try again"

    visit '/users/sign_out'

    visit '/'

    click_link 'Sign in'

    find "div.sign_in_bar"
  end

  it 'he should not be able to sign in with false credentials' do
    user = FactoryGirl.create :active_user

    visit "/"

    click_link 'Sign in'

    fill_in "user_login", :with => user.email
    fill_in "user_password", :with => user.password + "1"
    click_button "Sign in"

    page.should have_content "Your login credentials were incorrect. Please check and try again"
  end
end
