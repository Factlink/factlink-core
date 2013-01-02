require_relative '../../../app/interactors/queries/users_by_ids.rb'

describe Queries::UsersByIds do
  let(:user1)          {{id: 1, name: ''   , username: 'one', location: 'somewhere', biography: nil, gravatar_hash: 'asdfasdf1'}}
  let(:user2)          {{id: 2, name: 'TW0', username: 'two', location: 'overthere', biography: nil, gravatar_hash: 'asdfasdf2'}}
  let(:user3)          {{id: 3, name: ''   , username: 'tri', location: nil, biography: 'bladiebla', gravatar_hash: 'asdfasdf3'}}
  let(:mock_user1)     {mock('user', user1)}
  let(:mock_user2)     {mock('user', user2)}
  let(:mock_user3)     {mock('user', user3)}
  let(:mash_user1)     {OpenStruct.new(user1)}
  let(:mash_user2)     {OpenStruct.new(user2)}
  let(:mash_user3)     {OpenStruct.new(user3)}

  before do
    stub_const "User", Class.new
    stub_const "Pavlov::ValidationError", Class.new(StandardError)
  end

  it 'throws when initialized with a argument that is not a hexadecimal string' do
    expect { Queries::UsersByIds.new ['g6'], current_user: mock()}.
      to raise_error(Pavlov::ValidationError, 'id should be an hexadecimal string.')
  end

  describe ".call" do
    it "should work with an empty list of ids" do
      User.should_receive(:any_in).with(_id: []).and_return([])
      result = Queries::UsersByIds.new([], current_user: mock_user1).call
      expect(result).to eq([])
    end

    it "should work with multiple ids" do
      User.should_receive(:any_in).with(_id: [1, 2, 3]).and_return([mock_user1, mock_user2, mock_user3])
      result = Queries::UsersByIds.new([1, 2, 3], current_user: mock_user1).call
      expect(result).to eq([mash_user1, mash_user2, mash_user3])
    end
  end
end
