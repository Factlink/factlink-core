require 'pavlov_helper'
require_relative '../../../../app/interactors/backend/users.rb'

describe Backend::Users do
  include PavlovSupport

  before do
    stub_classes 'User'
  end

  describe '.user_by_username' do
    it 'retrieves a user' do
      search_username = "GERARD"

      user = double
      user.stub(id:11)
      User.should_receive(:find_by).with(username: /^#{search_username.downcase}$/i).
           and_return(user)

      result = Backend::Users.user_by_username(username: search_username)

      expect(result.id).to eq(user.id)
    end
  end
end
