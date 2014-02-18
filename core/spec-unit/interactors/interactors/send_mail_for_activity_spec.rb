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
      pavlov_options = { current_user: double }

      interactor = described_class.new activity: activity, pavlov_options: pavlov_options

      Pavlov.stub(:query)
            .with(:'object_ids_by_activity',
                      activity: activity, class_name: 'GraphUser',
                      list: :notifications,
                      pavlov_options: pavlov_options)
            .and_return(graph_user_ids)

      Pavlov.stub(:query)
        .with(:'users/filter_mail_subscribers', graph_user_ids: graph_user_ids, type: 'mailed_notifications', pavlov_options: pavlov_options)
        .and_return([dead_user])

      Resque.should_receive(:enqueue).with(Commands::SendActivityMailToUser,
        user_id: dead_user.id, activity_id: activity.id, pavlov_options: pavlov_options)

      interactor.call
    end
  end
end
