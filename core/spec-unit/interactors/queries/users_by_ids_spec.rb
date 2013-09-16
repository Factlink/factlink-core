require 'pavlov_helper'
require_relative '../../../app/interactors/queries/users_by_ids.rb'

describe Queries::UsersByIds do
  before do
    stub_const "User", Class.new
    stub_const "Pavlov::ValidationError", Class.new(StandardError)
    stub_const "KillObject", Class.new
  end

  it 'throws when initialized with a argument that is not a hexadecimal string' do
    expect { described_class.new({ user_ids: ['g6'], pavlov_options: { current_user: double() }}).call}.
      to raise_error(Pavlov::ValidationError, 'id should be an hexadecimal string.')
  end

  describe '#call' do
    it 'should work with an empty list of ids' do
      User.stub(:any_in).with(_id: []).and_return([])
      result = described_class.new(user_ids: [], pavlov_options: { current_user: double }).call
      expect(result).to eq([])
    end

    it 'should work with multiple ids' do
      user_ids = [0, 1, 2]
      users = [double, double, double]
      dead_users = [double, double, double]
      User.stub(:any_in).with(_id: user_ids).and_return(users)

      KillObject.stub(:user).with(users[0]).and_return(dead_users[0])
      KillObject.stub(:user).with(users[1]).and_return(dead_users[1])
      KillObject.stub(:user).with(users[2]).and_return(dead_users[2])

      result = described_class.new(user_ids: user_ids, pavlov_options: { current_user: double }).call

      expect(result).to eq(dead_users)
    end
  end
end
