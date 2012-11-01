require File.expand_path('../../../app/interactors/send_mail_for_activity_interactor.rb', __FILE__)
require_relative 'interactor_spec_helper'

describe SendMailForActivityInteractor do

  before do
    stub_classes 'Queries::UsersByGraphUserIds', 'Commands::SendActivityMailToUser', 'Queries::ObjectIdsByActivity'
  end

  describe '.execute' do
    it 'correctly' do
      user = mock()

      activity = mock()

      SendMailForActivityInteractor.any_instance.stub(authorized?: true)
      interactor = SendMailForActivityInteractor.new activity

      interactor.should_receive(:recipients).and_return([user])

      should_receive_new_with_and_receive_execute(
        Commands::SendActivityMailToUser, user, activity, {})

      interactor.execute
    end
  end

  describe '.recipients' do
    it 'returns only the users which want to receive notifications' do
      user2 = mock('user2', receives_mailed_notifications: true)
      user1 = mock('user1', receives_mailed_notifications: false)

      SendMailForActivityInteractor.any_instance.stub(authorized?: true)
      interactor = SendMailForActivityInteractor.new mock()

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

      SendMailForActivityInteractor.any_instance.stub(authorized?: true)
      interactor = SendMailForActivityInteractor.new activity

      should_receive_new_with_and_receive_execute(
        Queries::ObjectIdsByActivity, activity, "GraphUser", :notifications, {}).and_return(graph_user_ids)

      should_receive_new_with_and_receive_execute(
        Queries::UsersByGraphUserIds, graph_user_ids, {}).and_return([user2, user1])

      expect(interactor.users_by_graph_user_ids).to eq([user2, user1])
    end
  end
end
