require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/stream/add_activities'

describe Commands::Stream::AddActivities do
  include PavlovSupport

  describe '#call' do
    it 'should add the activities interleaved with existing activities' do
      activities = [double, double, double]
      user = double :user, graph_user: (double stream_activities: double)

      pavlov_options = { current_user: user }
      command = described_class.new activities: activities,
        pavlov_options: pavlov_options

      activities[0].should_receive(:add_to_list_with_score)
                   .with(user.graph_user.stream_activities)
      activities[1].should_receive(:add_to_list_with_score)
                   .with(user.graph_user.stream_activities)
      activities[2].should_receive(:add_to_list_with_score)
                   .with(user.graph_user.stream_activities)

      command.call
    end
  end
end
