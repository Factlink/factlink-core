require File.expand_path('../../../../app/interactors/queries/user_by_username.rb', __FILE__)

describe Queries::MessagesForConversation do
  before do
    stub_classes 'User'
  end


  describe '.execute' do
    it 'retrieves a user' do
      search_username = mock()
      user = mock()
      user.stub(id:11)

      User.should_receive(:first).with(conditions: { username: search_username}).
           and_return(user)

      query = Queries::UserByUsername.new(search_username)
      result = query.execute

      expect(result.id).to eq(user.id)
    end
  end

end

