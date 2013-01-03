require 'pavlov_helper'
require_relative '../../../app/interactors/interactors/send_mail_for_activity.rb'

describe Interactors::SendMailForActivity do
  include PavlovSupport

  before do
    stub_classes 'Queries::UsersByGraphUserIds', 'Commands::SendActivityMailToUser', 'Queries::ObjectIdsByActivity'
  end

  describe '.call' do
    it 'correctly' do
      user = mock(id: 1)

      activity = mock(id: 2)

      Interactors::SendMailForActivity.any_instance.stub(authorized?: true)
      interactor = Interactors::SendMailForActivity.new activity

      interactor.should_receive(:recipients).and_return([user])

      interactor.should_receive(:command).with(:send_activity_mail_to_user, user.id, activity.id)

      interactor.call
    end
  end

  describe '.recipients' do
    it 'returns only the users which want to receive notifications' do
      user2 = mock('user2', receives_mailed_notifications: true)
      user1 = mock('user1', receives_mailed_notifications: false)

      Interactors::SendMailForActivity.any_instance.stub(authorized?: true)
      interactor = Interactors::SendMailForActivity.new mock()

      interactor.should_receive(:users_by_graph_user_ids).
                 and_return([user1,user2])

      expect(interactor.recipients).to eq([user2])
    end
  end

  describe '.users_by_graph_user_ids' do
    it 'calls the relevant queries to retrieve users' do
      user2 = mock()
      user1 = mock()
      graph_user_ids = mock()
      activity = mock()

      Interactors::SendMailForActivity.any_instance.stub(authorized?: true)
      interactor = Interactors::SendMailForActivity.new activity

      interactor.should_receive(:query).with(:object_ids_by_activity, activity, "GraphUser", :notifications).
        and_return(graph_user_ids)

      interactor.should_receive(:query).with(:users_by_graph_user_ids, graph_user_ids).
        and_return([user2, user1])

      expect(interactor.users_by_graph_user_ids).to eq([user2, user1])
    end
  end
end
