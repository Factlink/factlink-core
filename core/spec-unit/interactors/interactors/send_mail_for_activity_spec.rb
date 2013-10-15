require 'pavlov_helper'
require_relative '../../../app/interactors/interactors/send_mail_for_activity.rb'

describe Interactors::SendMailForActivity do
  include PavlovSupport

  before do
    stub_classes 'Commands::SendActivityMailToUser', 'Resque', 'GraphUser'
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
      user_notification1 = double
      user_notification2 = double
      user1 = double(user_notification: user_notification1)
      user2 = double(user_notification: user_notification2)

      user_notification1.stub(:can_receive?).with('mailed_notifications').and_return(false)
      user_notification2.stub(:can_receive?).with('mailed_notifications').and_return(true)

      described_class.any_instance.stub(authorized?: true)
      interactor = described_class.new activity: double

      interactor.should_receive(:users).
                 and_return([user1, user2])

      expect(interactor.recipients).to eq([user2])
    end
  end

  describe '#users' do
    it 'calls the relevant queries to retrieve users' do
      user2 = double
      user1 = double
      graph_user1 = double(id: '1', user: user1)
      graph_user2 = double(id: '2', user: user2)
      activity = double

      described_class.any_instance.stub(authorized?: true)
      interactor = described_class.new activity: activity

      Pavlov.stub(:query)
            .with(:'object_ids_by_activity',
                      activity: activity, class_name: "GraphUser",
                      list: :notifications)
            .and_return([graph_user1.id, graph_user2.id])

      GraphUser.stub(:[]).with(graph_user1.id).and_return(graph_user1)
      GraphUser.stub(:[]).with(graph_user2.id).and_return(graph_user2)

      expect(interactor.users).to eq([user1, user2])
    end
  end
end
