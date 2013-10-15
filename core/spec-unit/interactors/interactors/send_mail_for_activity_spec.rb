require 'pavlov_helper'
require_relative '../../../app/interactors/interactors/send_mail_for_activity.rb'

describe Interactors::SendMailForActivity do
  include PavlovSupport

  before do
    stub_classes 'Commands::SendActivityMailToUser', 'Resque'
  end

  describe '#call' do
    it do
      dead_user = double(id: 1)
      activity = double(id: 2)
      graph_user_ids = ['1', '2']

      described_class.any_instance.stub(authorized?: true)
      interactor = described_class.new activity: activity

      Pavlov.stub(:query)
            .with(:'object_ids_by_activity',
                      activity: activity, class_name: 'GraphUser',
                      list: :notifications)
            .and_return(graph_user_ids)

      Pavlov.stub(:query)
        .with(:'users/filter_recipients', graph_user_ids: graph_user_ids, type: 'mailed_notifications')
        .and_return([dead_user])

      Resque.should_receive(:enqueue).with(Commands::SendActivityMailToUser,
        user_id: dead_user.id, activity_id: activity.id, pavlov_options: {})

      interactor.call
    end
  end
end
