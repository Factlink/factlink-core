require 'acceptance_helper'

describe 'Reserving an account', type: :feature do
  it 'should get success note with valid details' do
    visit '/'
    disable_html5_validations(page)

    within '.header' do
      fill_in 'user[full_name]', with: 'Jane Doe'
      fill_in 'user[email]',    with: 'janedoe@example.org'

      click_button 'Create account'
    end

    page.should have_content("set up your account")
  end

  it 'should get failure note with invalid name' do
    visit '/'
    disable_html5_validations(page)

    within '.header' do
      fill_in 'user[full_name]', with: ''
      fill_in 'user[email]',    with: 'janedoe@example.org'

      click_button 'Create account'

      page.should have_content('Full name is required')
    end
  end

  it 'should make the username appear in the user list' do
    name = 'Jane Doe'

    visit '/'
    disable_html5_validations(page)

    within '.footer' do
      fill_in 'user[full_name]', with: name
      fill_in 'user[email]',    with: 'janedoe@example.org'
      click_button 'Create account'
    end

    admin = create(:full_user, :confirmed, :admin)
    switch_to_user admin

    find('.navbar .topbar-dropdown').click
    find('.navbar').should have_content('Admin')

    visit '/a/users'

    within(find("#main-wrapper table tr>td", text: name).parent) do
      page.should have_content('unconfirmed')
    end
  end

  it 'user should receive a confirmation email and should be able to confirm its e-mail address' do
    email_address = 'janedoe@example.org'

    clear_emails

    visit '/'
    disable_html5_validations(page)
    within '.footer' do
      fill_in 'user[full_name]', with: 'Jane Doe'
      fill_in 'user[email]',    with: email_address

      click_button 'Create account'
    end

    eventually_succeeds do
      open_email email_address
      current_email.subject
    end

    current_email.find(:xpath, '//a', text: 'Confirm email').click

    page.should have_content "set up your account here"
  end

end
