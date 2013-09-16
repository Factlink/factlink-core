require 'pavlov_helper'
require_relative '../../../app/interactors/queries/users_by_ids.rb'

describe Queries::UsersByIds do
  let(:user1)          {{id: 1, name: ''   , username: 'one', location: 'somewhere', biography: nil, gravatar_hash: 'asdfasdf1'}}
  let(:user2)          {{id: 2, name: 'TW0', username: 'two', location: 'overthere', biography: nil, gravatar_hash: 'asdfasdf2'}}
  let(:user3)          {{id: 3, name: ''   , username: 'tri', location: nil, biography: 'bladiebla', gravatar_hash: 'asdfasdf3'}}
  let(:double_user1)     {double('user', user1)}
  let(:double_user2)     {double('user', user2)}
  let(:double_user3)     {double('user', user3)}

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
    it "should work with an empty list of ids" do
      User.stub(:any_in).with(_id: []).and_return([])
      result = described_class.new(user_ids: [], pavlov_options: { current_user: double_user1 }).call
      expect(result).to eq([])
    end

    it "should work with multiple ids" do
      User.stub(:any_in).with(_id: [1, 2, 3]).and_return([double_user1, double_user2, double_user3])

      mash_user1 = double
      mash_user2 = double
      mash_user3 = double
      KillObject.stub(:user).with(double_user1).and_return(mash_user1)
      KillObject.stub(:user).with(double_user2).and_return(mash_user2)
      KillObject.stub(:user).with(double_user3).and_return(mash_user3)

      result = described_class.new(user_ids: [1, 2, 3], pavlov_options: { current_user: double_user1 }).call

      expect(result).to eq([mash_user1, mash_user2, mash_user3])
    end
  end
end
