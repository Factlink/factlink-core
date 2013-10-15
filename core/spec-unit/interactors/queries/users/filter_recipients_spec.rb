require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/users/filter_recipients.rb'

describe Interactors::Queries::FilterRecipients do
  include PavlovSupport

  before do
    stub_classes 'GraphUser'
  end

  describe '#call' do
    it 'returns only the users which want to receive digest' do
      user_notification1 = double
      user_notification2 = double
      user1 = double(id: '1a', user_notification: user_notification1)
      user2 = double(id: '2b', user_notification: user_notification2)
      dead_user2 = double
      graph_user1 = double(id: '1', user: user1)
      graph_user2 = double(id: '2', user: user2)
      graph_user_ids = [graph_user1.id, graph_user2.id]
      query = described_class.new graph_user_ids: graph_user_ids, type: 'digest'

      GraphUser.stub(:[]).with(graph_user1.id).and_return(graph_user1)
      GraphUser.stub(:[]).with(graph_user2.id).and_return(graph_user2)
      user_notification1.stub(:can_receive?).with('digest').and_return(false)
      user_notification2.stub(:can_receive?).with('digest').and_return(true)
      Pavlov.stub(:query).with(:users_by_ids, user_ids: [user2.id]).and_return([dead_user2])

      expect(query.call).to eq([dead_user2])
    end
  end
end
