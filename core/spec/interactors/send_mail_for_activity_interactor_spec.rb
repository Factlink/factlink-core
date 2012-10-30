require File.expand_path('../../../app/interactors/send_mail_for_activity_interactor.rb', __FILE__)
require_relative 'interactor_spec_helper'

describe SendMailForActivityInteractor do

  before do
    stub_classes 'Activity::Listener', 'Queries::UsersByGraphUserIds', 'Commands::SendActivityMailToUser'
  end

  describe '.filter' do
    it do
      activity = mock()
      listener = mock()
      listener_hash = mock()

      listener_hash.should_receive(:[]).and_return(listener)
      Activity::Listener.stub(all: listener_hash)

      SendMailForActivityInteractor.any_instance.stub(authorized?: true)

      interactor = SendMailForActivityInteractor.new activity

      interactor.filter
    end
  end

  describe '.execute' do
    it 'correctly' do
      users = [mock(), mock()]
      graph_user_ids = [mock(),mock()]

      activity = mock()
      listener = mock()

      listener.should_receive(:add_to).with(activity).and_return(graph_user_ids)

      graph_user_ids.each_with_index do |graph_user_id, index|
        should_receive_new_with_and_receive_execute(
          Commands::SendActivityMailToUser, activity, users[index], {})
      end

      should_receive_new_with_and_receive_execute(
        Queries::UsersByGraphUserIds, graph_user_ids, {}).and_return(users)

      SendMailForActivityInteractor.any_instance.stub(authorized?: true)

      interactor = SendMailForActivityInteractor.new activity
      interactor.stub(filter:listener)

      interactor.execute
    end
  end
end
