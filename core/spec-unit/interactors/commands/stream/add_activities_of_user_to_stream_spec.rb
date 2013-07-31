require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/stream/add_activities_of_user_to_stream'

describe Commands::Stream::AddActivitiesOfUserToStream do
  include PavlovSupport

  describe '#call' do
    it 'adds relevant activities to the users stream' do
      graph_user_id = 3
      activities = double

      command = described_class.new graph_user_id: graph_user_id

      Pavlov.should_receive(:old_query)
            .with(:'activities/for_followers_stream', graph_user_id)
            .and_return(activities)
      Pavlov.should_receive(:old_command)
            .with(:'stream/add_activities', activities)

      command.call
    end
  end
end
