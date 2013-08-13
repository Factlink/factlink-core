require 'pavlov_helper'
require_relative '../../../app/interactors/commands/create_activity.rb'

describe Commands::CreateActivity do
  include PavlovSupport

  let(:current_user) { double('current_user', id: 2) }
  let(:graph_user)   { double('user',id: 1, user_id: current_user.id) }
  let(:other_graph_user)   { double('user',id: 1, user_id: current_user.id + 1)  }

  before do
    stub_classes 'Activity'
  end

  describe '#call' do
    it 'correctly' do
      action = :test
      activity_subject = double
      activity_object = double
      command = described_class.new graph_user: graph_user, action: action,
        subject: activity_subject, object: activity_object
      Activity.should_receive(:create).with(user: graph_user, action: action, subject: activity_subject, object: activity_object )

      command.call
    end
  end
end
