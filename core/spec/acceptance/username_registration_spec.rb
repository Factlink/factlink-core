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

    eventually_succeeds do
      open_email email_address
      current_email.subject
    end

    current_email.find(:xpath, '//a', text: 'Confirm email').click

    page.should have_content "set up your account here"
  end

end
