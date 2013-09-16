require 'pavlov_helper'
require_relative '../../../app/interactors/queries/users_by_ids.rb'

describe Queries::UsersByIds do
  include PavlovSupport

  before do
    stub_classes 'User', 'KillObject'
  end

  it 'throws when initialized with a argument that is not a hexadecimal string' do
    expect { described_class.new({ user_ids: ['g6'], pavlov_options: { current_user: double() }}).call}.
      to raise_error(Pavlov::ValidationError, 'id should be an hexadecimal string.')
  end

  describe '#call' do
    it 'should work with an empty list of ids' do
      query = described_class.new(user_ids: [], pavlov_options: { current_user: double })

      User.stub(:any_in).with(_id: []).and_return([])

      expect(query.call).to eq []
    end

    it 'should work with multiple ids' do
      user_ids = [0, 1]
      users = [double, double]
      dead_users = [double, double]
      query = described_class.new(user_ids: user_ids, pavlov_options: { current_user: double })

      User.stub(:any_in).with(_id: user_ids).and_return(users)
      KillObject.stub(:user).with(users[0]).and_return(dead_users[0])
      KillObject.stub(:user).with(users[1]).and_return(dead_users[1])

      expect(query.call).to eq dead_users
    end
  end
end
