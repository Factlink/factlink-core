require 'integration_helper'

# describe 'Reserving a username', type: :request do

#   it 'should be reservable form the frontpage' do
#     visit '/'

#     fill_in 'user_username', with: 'teh_user'
#     fill_in 'user_email',    with: 'teh_user@factlink.com'

#     click_button 'Reserve'

#     page.should have_content('You have successfully reserved your username!')
#   end

# end
describe 'Password recovery', type: :request do

  before do
    @user = make_user
  end

  it 'should inform the user the email has been send' do
    visit '/'
    click_link "Can't access?"
    page.should have_content('Forgot your password?')
  end

end
