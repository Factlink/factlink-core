require 'integration_helper'

describe 'Reserving a username', type: :request do

  it 'should get success note with valid username' do
    visit '/'

    fill_in 'user_username', with: random_username
    fill_in 'user_email',    with: random_email

    click_button 'Reserve'

    page.should have_content('You have successfully reserved your username!')
  end

  it 'should get failure note with invalid username' do
    visit '/'

    fill_in 'user_username', with: 'teh_user_has_a_way_too_long_username'
    fill_in 'user_email',    with: random_email

    click_button 'Reserve'

    page.should have_content('Registration failed')
  end

  it 'should make the username appear in the reserved user list' do
    username = random_username

    visit '/'

    fill_in 'user_username', with: username
    fill_in 'user_email',    with: random_email

    click_button 'Reserve'

    create_admin_and_login

    within(:css, 'a.dropdown-toggle') do
      page.should have_content('Admin')
    end

    visit '/a/users/reserved'

    within(find("#main-wrapper table tr>td", text: username).parent) do
      page.should_not have_content('confirmed')
    end
  end
end
