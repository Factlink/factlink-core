require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/users/filter_recipients.rb'

describe Interactors::Queries::FilterRecipients do
  include PavlovSupport

  before do
    stub_classes 'UserNotification'
  end

  describe '#call' do
    it 'returns only the users which want to receive digest' do
      user = double(id: '1a')
      dead_user = double
      graph_user_ids = ['1', '2']
      query = described_class.new graph_user_ids: graph_user_ids, type: 'digest'

      scope = double

      UserNotification.stub(:users_receiving).with('digest').and_return(scope)
      scope.stub(:any_in).with(graph_user_id: graph_user_ids).and_return([user])

      Pavlov.stub(:query).with(:users_by_ids, user_ids: [user.id]).and_return([dead_user])

      expect(query.call).to eq([dead_user])
    end
  end
end
