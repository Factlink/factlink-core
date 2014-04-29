require 'acceptance_helper'

describe 'A user deletes his account', type: :feature do

  before do
    user = create :user, :confirmed,
      password: 'my_password',
      password_confirmation: 'my_password'

    sign_in_user user
    visit edit_user_path user

    find('a', text: 'Delete account').click
  end

  it 'with the correct password' do
    find('.spec-delete-password').set 'my_password'

    click_button 'Delete my entire account'

    page.should have_content 'Your account has been deleted.'
  end

  it 'with an incorrect password' do
    find('.spec-delete-password').set 'A WRONG PASSWORD'

    click_button 'Delete my entire account'

    page.should have_content 'Your account could not be deleted. Did you enter the correct password?'
  end
end
