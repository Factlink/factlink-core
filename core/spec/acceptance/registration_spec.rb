require 'acceptance_helper'

describe 'Reserving an account', type: :feature do
  it 'should get success note with valid details' do
    visit factlink_accounts_new_path
    disable_html5_validations(page)
    fill_in 'user_new_account[full_name]',             with: 'Jane Doe'
    fill_in 'user_new_account[email]',                 with: 'janedoe@example.org'
    fill_in 'user_new_account[password]',              with: '123hoi'
    fill_in 'user_new_account[password_confirmation]', with: '123hoi'
    click_button 'Create account'

    page.should have_content('Redirecting you back to the application!')
  end

  it 'should get failure note with invalid name' do
    visit factlink_accounts_new_path
    disable_html5_validations(page)
    click_button 'Create account'

    page.should have_content('is required')
  end

  it 'should make the username appear in the user list' do
    name = 'Jane Doe'

    visit factlink_accounts_new_path
    disable_html5_validations(page)
    fill_in 'user_new_account[full_name]',             with: name
    fill_in 'user_new_account[email]',                 with: 'janedoe@example.org'
    fill_in 'user_new_account[password]',              with: '123hoi'
    fill_in 'user_new_account[password_confirmation]', with: '123hoi'
    click_button 'Create account'

    admin = create(:user, :confirmed, :admin)
    switch_to_user admin
    visit '/a/users'

    within(find("#main-column table tr>td", text: name).parent) do
      page.should have_content('unconfirmed')
    end
  end

  it 'user should receive a confirmation email and should be able to confirm its e-mail address' do
    email_address = 'janedoe@example.org'

    clear_emails

    visit factlink_accounts_new_path
    disable_html5_validations(page)
    fill_in 'user_new_account[full_name]',             with: 'Jane Doe'
    fill_in 'user_new_account[email]',                 with: email_address
    fill_in 'user_new_account[password]',              with: '123hoi'
    fill_in 'user_new_account[password_confirmation]', with: '123hoi'
    click_button 'Create account'

    eventually_succeeds do
      open_email email_address
      current_email.subject
    end

    current_email.find(:xpath, '//a', text: 'Confirm email address').click

    user = Backend::Users.user_by_username(username: 'jane_doe')
    eventually_succeeds do
      expect(user).to be_confirmed
    end
  end

end
