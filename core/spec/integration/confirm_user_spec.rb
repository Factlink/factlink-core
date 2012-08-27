require 'integration_helper'

describe 'When a username is reserved', type: :request do
  it 'the user should receive a confirmation email' do
    email = random_email

    clear_emails

    visit '/'

    fill_in 'user_username', with: random_username
    fill_in 'user_email',    with: email

    click_button 'Reserve'

    open_email email

    current_email.have_content 'Confirm my email address'
  end

  it 'the user should be able to confirm his email address' do
    email = random_email

    clear_emails

    visit '/'

    fill_in 'user_username', with: random_username
    fill_in 'user_email',    with: email

    click_button 'Reserve'

    open_email email

    current_email.click_link 'Confirm my email address'

    page.should have_content "Email confirmed. Awaiting account approval."
  end
end
