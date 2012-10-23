require File.expand_path('../../../../app/interactors/queries/conversations_list.rb', __FILE__)

describe Queries::ConversationsList do
  let(:user)           {mock('user', id: 13)}
  let(:conversation1) {{id: 1, fact_data_id: 100, recipient_ids: [1, 2, 13]}}
  let(:conversation2) {{id: 2, fact_data_id: 200, recipient_ids: [1, 3, 13]}}

  before do
    stub_const 'User', Class.new
  end

  it 'it initializes correctly' do
    query = Queries::ConversationsList.new current_user: mock()
    query.should_not be_nil
  end

  describe '.execute' do
    it "returns a list when the user has conversations" do
      User.should_receive(:find).with(user.id).and_return(user)
      user.should_receive(:conversations).
        and_return([mock('conversation', conversation1), mock('conversation', conversation2)])

      result = Queries::ConversationsList.execute(current_user: user)
      expect(result).to eq([Hashie::Mash.new(conversation1), Hashie::Mash.new(conversation2)])
    end

    it "returns an empty list when the user has conversations" do
      User.should_receive(:find).with(user.id).and_return(user)
      user.should_receive(:conversations).and_return([])

      result = Queries::ConversationsList.execute(current_user: user)
      expect(result).to eq([])
    end
  end
end
