require 'acceptance_helper'

describe 'A user deletes his account', type: :feature do

  before do
    user = create :full_user, :confirmed,
      password: 'my_password',
      password_confirmation: 'my_password'

    sign_in_user user
    visit edit_user_path user

    click_link 'Delete account'
  end

  it 'with the correct password' do
    fill_in 'user_password', with: 'my_password'

    click_button 'Delete my entire account'

    page.should have_content 'Your account has been deleted.'
  end

  it 'with an incorrect password' do
    fill_in 'user_password', with: 'A WRONG PASSWORD'

    click_button 'Delete my entire account'

    page.should have_content 'Your account could not be deleted. Did you enter the correct password?'
  end
end
