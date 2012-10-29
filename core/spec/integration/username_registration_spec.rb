require 'integration_helper'

describe 'Reserving a username', type: :request, js: true do

  it 'should get success note with valid username' do
    visit '/'
    disable_html5_validations(page)

    fill_in 'user[username]', with: random_username
    fill_in 'user[email]',    with: random_email

    find('div.success').visible?.should be_false

    click_button 'Reserve my username'

    sleep 2

    find('div.success').visible?.should be_true

    #page.should have_content('You have successfully reserved your username!')
  end

  it 'should get failure note with invalid username' do
    visit '/'
    disable_html5_validations(page)

    fill_in 'user[username]', with: 'teh_user_has_a_way_too_long_username'
    fill_in 'user[email]',    with: random_email

    click_button 'Reserve my username'

    page.should have_content('username invalid. A maximum of 16 characters is allowed')
  end

  it 'should make the username appear in the reserved user list' do
    username = random_username

    visit '/'
    disable_html5_validations(page)

    fill_in 'user[username]', with: username
    fill_in 'user[email]',    with: random_email

    click_button 'Reserve my username'

    create_admin_and_login

    within(:css, 'li.dropdown-submenu a') do
      page.should have_content('Admin')
    end

    visit '/a/users/reserved'

    within(find("#main-wrapper table tr>td", text: username).parent) do
      page.should_not have_content('confirmed')
    end
  end

  pending 'user should receive a confirmation email and should be able to confirm its e-mail address' do
    email_address = random_email

    clear_emails

    visit '/'
    disable_html5_validations(page)

    fill_in 'user[username]', with: random_username
    fill_in 'user[email]',    with: email_address

    click_button 'Reserve my username'

    sleep 2

    open_email email_address

    current_email.click_link 'Confirm my email address'

    page.should have_content "Email confirmed. Awaiting account approval."
  end
end
