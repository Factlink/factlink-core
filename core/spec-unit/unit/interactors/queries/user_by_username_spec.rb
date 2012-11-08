require 'pavlov_helper'
require File.expand_path('../../../../../app/interactors/queries/user_by_username.rb', __FILE__)

describe Queries::UserByUsername do
  include PavlovSupport

  before do
    stub_classes 'User'
  end

  describe '.execute' do
    it 'retrieves a user' do
      search_username = "GERARD"

      user = mock()
      user.stub(id:11)

      User.should_receive(:first).with(conditions: { username: /^#{search_username.downcase}$/i}).
           and_return(user)

      query = Queries::UserByUsername.new(search_username)
      result = query.execute

      expect(result.id).to eq(user.id)
    end
  end

end

