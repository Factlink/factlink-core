require 'pavlov_helper'
require_relative '../../../app/interactors/queries/user_by_username.rb'

describe Queries::UserByUsername do
  include PavlovSupport

  before do
    stub_classes 'User'
  end

  describe '#call' do
    it 'retrieves a user' do
      search_username = "GERARD"

      user = double
      user.stub(id:11)
      query = described_class.new(username: search_username)

      User.should_receive(:find_by).with(username: /^#{search_username.downcase}$/i).
           and_return(user)

      result = query.call

      expect(result.id).to eq(user.id)
    end
  end
end
