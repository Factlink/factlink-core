require 'acceptance_helper'

describe 'Reserving a username', type: :feature do
  it 'should get success note with valid username' do
    visit '/'
    disable_html5_validations(page)

    within '.header' do
      fill_in 'user[username]', with: random_username
      fill_in 'user[email]',    with: random_email

      find('.success', visible:false).visible?.should be_false

      click_button 'Reserve my username'

      page.should have_content("Great, you're almost finished! Please click the confirmation link in the email we've sent you")
      find('form.success')
      find('div.success')
    end

    within '.footer' do
      page.should have_content("Great, you're almost finished! Please click the confirmation link in the email we've sent you")
      find('form.success')
      find('div.success')
    end

  end

  it 'should get failure note with invalid username' do
    visit '/'
    disable_html5_validations(page)

    within '.header' do
      fill_in 'user[username]', with: 't'
      fill_in 'user[email]',    with: random_email

      click_button 'Reserve my username'

      page.should have_content('username at least 2 characters needed')
    end
  end

  it 'should make the username appear in the reserved user list' do
    username = random_username

    visit '/'
    disable_html5_validations(page)

    within '.footer' do
      fill_in 'user[username]', with: username
      fill_in 'user[email]',    with: random_email
      click_button 'Reserve my username'
    end

    create_admin_and_login

    find('.navbar .topbar-dropdown').click
    find('.navbar').should have_content('Admin')

    visit '/a/users/reserved'

    within(find("#main-wrapper table tr>td:first-child", text: username).parent) do
      page.should_not have_content('confirmed')
    end
  end

  it 'user should receive a confirmation email and should be able to confirm its e-mail address' do
    email_address = random_email

    clear_emails

    visit '/'
    disable_html5_validations(page)
    within '.footer' do
      fill_in 'user[username]', with: random_username
      fill_in 'user[email]',    with: email_address

      click_button 'Reserve my username'
    end

    open_email email_address

    visit current_email.find('a')[:href]

    page.should have_content "Email confirmed. Awaiting account approval."
  end

end
