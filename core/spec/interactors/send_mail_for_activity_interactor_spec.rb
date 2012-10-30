require File.expand_path('../../../app/interactors/send_mail_for_activity_interactor.rb', __FILE__)
require_relative 'interactor_spec_helper'

describe SendMailForActivityInteractor do

  before do
    stub_classes 'Activity::Listener'
    stub_const 'Commands::SendActivityMailToUser', Class.new
  end

  describe '.filter' do
    it do
      activity = mock()
      listener = mock()
      listener_hash = mock()

      listener_hash.should_receive(:[]).and_return(listener)
      Activity::Listener.stub(all: listener_hash)

      interactor = SendMailForActivityInteractor.new activity

      interactor.filter
    end
  end

  describe '.execute' do
    it 'correctly' do
      gu_ids = [10,14]

      activity = mock()
      listener = mock()

      listener.should_receive(:add_to).with(activity).and_return(gu_ids)

      gu_ids.each do |graph_user_id|
        should_receive_new_with_and_receive_execute(
          Commands::SendActivityMailToUser, activity, graph_user_id, {})
      end

      interactor = SendMailForActivityInteractor.new activity
      interactor.stub(filter:listener)

      interactor.execute
    end
  end
end
