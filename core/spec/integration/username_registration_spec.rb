require 'integration_helper'

describe 'Reserving a username', type: :request do

  it 'should get success note with valid username' do
    visit '/'
    disable_html5_validations(page)

    fill_in 'top_registration_form_user_username', with: random_username
    fill_in 'top_registration_form_user_email',    with: random_email

    click_button 'Reserve my username'

    page.should have_content("Great, you’re almost finished! Please click the confirmation link in the email we’ve sent you.")
  end

  it 'should get failure note with invalid username' do
    visit '/'
    disable_html5_validations(page)

    fill_in 'top_registration_form_user_username', with: 'teh_user_has_a_way_too_long_username'
    fill_in 'top_registration_form_user_email',    with: random_email

    click_button 'Reserve my username'

    page.should have_content('Registration failed')
  end

  it 'should make the username appear in the reserved user list' do
    username = random_username

    visit '/'
    disable_html5_validations(page)

    fill_in 'top_registration_form_user_username', with: username
    fill_in 'top_registration_form_user_email',    with: random_email

    click_button 'Reserve my username'

    create_admin_and_login

    within(:css, 'a.dropdown-toggle') do
      page.should have_content('Admin')
    end

    visit '/a/users/reserved'

    within(find("#main-wrapper table tr>td", text: username).parent) do
      page.should_not have_content('confirmed')
    end
  end

  it 'user should receive a confirmation email and should be able to confirm its e-mail address' do
    clear_emails

    visit '/'
    disable_html5_validations(page)

    fill_in 'top_registration_form_user_username', with: random_username
    fill_in 'top_registration_form_user_email',    with: email

    click_button 'Reserve my username'

    email = random_email
    open_email email

    current_email.click_link 'Confirm my email address'

    page.should have_content "Email confirmed. Awaiting account approval."
  end
end
