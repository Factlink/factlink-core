require File.expand_path('../../../app/interactors/send_mail_for_activity_interactor.rb', __FILE__)
require_relative 'interactor_spec_helper'

describe SendMailForActivityInteractor do

  before do
    stub_classes 'Queries::UsersByGraphUserIds', 'Commands::SendActivityMailToUser', 'Queries::ObjectIdsByActivity'
  end

  describe '.execute' do
    it 'correctly' do
      user1 = mock('user', receives_mailed_notifications: false)
      user2 = mock('user', receives_mailed_notifications: true)
      graph_user_ids = mock()

      activity = mock()
      listener = mock()

      should_receive_new_with_and_receive_execute(
        Queries::ObjectIdsByActivity, activity, "GraphUser", :notifications, {}).and_return(graph_user_ids)

      should_receive_new_with_and_receive_execute(
        Queries::UsersByGraphUserIds, graph_user_ids, {}).and_return([user1, user2])

      should_receive_new_with_and_receive_execute(
        Commands::SendActivityMailToUser, user2, activity, {})

      SendMailForActivityInteractor.any_instance.stub(authorized?: true)

      interactor = SendMailForActivityInteractor.new activity
      interactor.stub(filter:listener)

      interactor.execute
    end
  end
end
