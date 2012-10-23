require File.expand_path('../../../../app/interactors/queries/users_for_conversations.rb', __FILE__)

describe Queries::UsersForConversations do
  let(:user1)          {{id: 1, name: ''   , username: 'one', location: 'somewhere', biography: nil, gravatar_hash: 'asdfasdf1'}}
  let(:user2)          {{id: 2, name: 'TW0', username: 'two', location: 'overthere', biography: nil, gravatar_hash: 'asdfasdf2'}}
  let(:user3)          {{id: 3, name: ''   , username: 'tri', location: nil, biography: 'bladiebla', gravatar_hash: 'asdfasdf3'}}
  let(:mock_user1)     {mock('user', user1)}
  let(:mock_user2)     {mock('user', user2)}
  let(:mock_user3)     {mock('user', user3)}
  let(:mash_user1)     {Hashie::Mash.new(user1)}
  let(:mash_user2)     {Hashie::Mash.new(user2)}
  let(:mash_user3)     {Hashie::Mash.new(user3)}
  let(:conversation10) {mock('conversation', id: 10, recipient_ids: [1, 2])}
  let(:conversation20) {mock('conversation', id: 20, recipient_ids: [1, 3])}

  before do
    stub_const "User", Class.new
    stub_const 'CanCan::AccessDenied', Class.new(RuntimeError)
  end

  it 'throws when initialized with a argument that is not a hexadecimal string' do
    expect { Queries::UsersForConversations.new [mock('conversation', id: 'g6')], current_user:mock()}.
      to raise_error(RuntimeError, 'id should be an hexadecimal string.')
  end

  describe ".authorized" do
    it 'works when the conversations contain the current user' do
      query = Queries::UsersForConversations.new [conversation10, conversation20], current_user: mock_user1
      query.should_not be_nil
    end

    it 'throws when one conversation does not contain the current user' do
      expect { Queries::UsersForConversations.new [conversation10, conversation20], current_user: mock_user3}.
        to raise_error(CanCan::AccessDenied, 'Unauthorized')
    end
  end

  context "with an empty list of conversations" do
    let(:query) {Queries::UsersForConversations.new([], current_user: mock_user1)}

    describe ".all_recipients_by_id" do
      it "should return an empty hash" do
        User.should_receive(:any_in).with(_id: []).and_return([])
        expect(query.all_recipients_by_id).to eq({})
      end
    end

    describe ".execute" do
      it "should return an empty hash" do
        User.should_receive(:any_in).with(_id: []).and_return([])
        expect(query.execute).to eq({})
      end
    end
  end

  context "with a conversation between two users" do
    let(:query) {Queries::UsersForConversations.new([conversation10], current_user: mock_user1)}

    describe ".all_recipients_by_id" do
      it "should return those users" do
        User.should_receive(:any_in).with(_id: [1, 2]).and_return([mock_user1, mock_user2])
        expect(query.all_recipients_by_id).to eq({1 => mock_user1, 2 => mock_user2})
      end
    end

    describe ".execute" do
      it "should return those users" do
        User.should_receive(:any_in).with(_id: [1, 2]).and_return([mock_user1, mock_user2])
        expect(query.execute).to eq({10 => [mash_user1, mash_user2]})
      end
    end
  end

  context "with multiple conversations" do
    let(:query) {Queries::UsersForConversations.new([conversation10, conversation20], current_user: mock_user1)}

    describe ".all_recipients_by_id" do
      it "should return those users" do
        User.should_receive(:any_in).with(_id: [1, 2, 3]).and_return([mock_user3, mock_user1, mock_user2])
        expect(query.all_recipients_by_id).to eq({1 => mock_user1, 2 => mock_user2, 3 => mock_user3})
      end
    end

    describe ".execute" do
      it "should return all users" do
        User.should_receive(:any_in).with(_id: [1, 2, 3]).and_return([mock_user3, mock_user1, mock_user2])
        expect(query.execute).to eq({10 => [mash_user1, mash_user2], 20 => [mash_user1, mash_user3]})
      end
    end
  end
end
