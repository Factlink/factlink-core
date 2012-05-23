require 'integration_helper'

describe 'Reserving a username', type: :request do

  it 'should get success note with valid username' do
    visit '/'

    fill_in 'user_username', with: 'teh_user'
    fill_in 'user_email',    with: 'teh_user@factlink.com'

    click_button 'Reserve'

    page.should have_content('You have successfully reserved your username!')
  end

  it 'should get failure note with invalid username' do
    visit '/'

    fill_in 'user_username', with: 'teh_user_has_a_way_too_long_username'
    fill_in 'user_email',    with: 'teh_user@factlink.com'

    click_button 'Reserve'

    page.should have_content('Registration failed')
  end
end
