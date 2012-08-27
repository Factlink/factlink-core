require 'integration_helper'

describe 'When a user signs in', type: :request do
  it 'and has not yet confirmed his email address it should fail' do
    user = FactoryGirl.create :user, approved: false

    sign_in_user(user)

    page.should have_content "Your account has not yet been approved"
  end
end
