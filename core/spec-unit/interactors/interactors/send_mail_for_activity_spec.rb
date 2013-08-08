require 'pavlov_helper'
require_relative '../../../app/interactors/interactors/send_mail_for_activity.rb'

describe Interactors::SendMailForActivity do
  include PavlovSupport

  before do
    stub_classes 'Queries::UsersByGraphUserIds', 'Commands::SendActivityMailToUser', 'Queries::ObjectIdsByActivity', 'Resque'
  end

  describe '#call' do
    it do
      user = double(id: 1)

      activity = double(id: 2)

      described_class.any_instance.stub(authorized?: true)
      interactor = described_class.new activity: activity

      interactor.should_receive(:recipients).and_return([user])

      Resque.should_receive(:enqueue).with(Commands::SendActivityMailToUser,
        user_id: user.id, activity_id: activity.id, pavlov_options: {})

      interactor.call
    end
  end

  describe '#recipients' do
    it 'returns only the users which want to receive notifications' do
      user2 = double('user2', receives_mailed_notifications: true)
      user1 = double('user1', receives_mailed_notifications: false)

      described_class.any_instance.stub(authorized?: true)
      interactor = described_class.new activity: double

      interactor.should_receive(:users_by_graph_user_ids).
                 and_return([user1,user2])

      expect(interactor.recipients).to eq([user2])
    end
  end

  describe '#users_by_graph_user_ids' do
    it 'calls the relevant queries to retrieve users' do
      user2 = double
      user1 = double
      graph_user_ids = double
      activity = double

      described_class.any_instance.stub(authorized?: true)
      interactor = described_class.new activity: activity

      Pavlov.should_receive(:old_query).with(:object_ids_by_activity, activity, "GraphUser", :notifications).
        and_return(graph_user_ids)

      Pavlov.should_receive(:old_query).with(:users_by_graph_user_ids, graph_user_ids).
        and_return([user2, user1])

      expect(interactor.users_by_graph_user_ids).to eq([user2, user1])
    end
  end
end
