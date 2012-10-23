require File.expand_path('../../../../app/interactors/queries/users_by_ids.rb', __FILE__)

describe Queries::UsersByIds do
  let(:user1)          {{id: 1, name: ''   , username: 'one', location: 'somewhere', biography: nil, gravatar_hash: 'asdfasdf1'}}
  let(:user2)          {{id: 2, name: 'TW0', username: 'two', location: 'overthere', biography: nil, gravatar_hash: 'asdfasdf2'}}
  let(:user3)          {{id: 3, name: ''   , username: 'tri', location: nil, biography: 'bladiebla', gravatar_hash: 'asdfasdf3'}}
  let(:mock_user1)     {mock('user', user1)}
  let(:mock_user2)     {mock('user', user2)}
  let(:mock_user3)     {mock('user', user3)}
  let(:mash_user1)     {Hashie::Mash.new(user1)}
  let(:mash_user2)     {Hashie::Mash.new(user2)}
  let(:mash_user3)     {Hashie::Mash.new(user3)}

  before do
    stub_const "User", Class.new
    stub_const 'CanCan::AccessDenied', Class.new(RuntimeError)
  end

  it 'throws when initialized with a argument that is not a hexadecimal string' do
    expect { Queries::UsersByIds.new ['g6'], current_user: mock()}.
      to raise_error(RuntimeError, 'id should be an hexadecimal string.')
  end

  describe ".execute" do
    it "should work with an empty list of ids" do
      User.should_receive(:any_in).with(_id: []).and_return([])
      result = Queries::UsersByIds.execute([], current_user: mock_user1)
      expect(result).to eq({})
    end

    it "should work with multiple ids" do
      User.should_receive(:any_in).with(_id: [1, 2, 3]).and_return([mock_user1, mock_user2, mock_user3])
      result = Queries::UsersByIds.execute([1, 2, 3], current_user: mock_user1)
      expect(result).to eq({1 => mash_user1, 2 => mash_user2, 3 => mash_user3})
    end
  end
end
