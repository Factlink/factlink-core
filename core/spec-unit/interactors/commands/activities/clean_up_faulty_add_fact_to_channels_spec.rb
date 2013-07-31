require 'pavlov_helper'

require_relative '../../../../app/interactors/commands/activities/clean_up_faulty_add_fact_to_channels'

describe Commands::Activities::CleanUpFaultyAddFactToChannels do
  include PavlovSupport
  before do
    stub_classes 'Activity'
  end
  describe '#call' do
    it 'should remove all non-channel add_fact activities' do
      activities_by_id = {
        1 => mock(:activity, object: mock(:channel, type: 'channel')),
        2 => mock(:activity, object: mock(:channel, type: 'created')),
        3 => mock(:activity, object: mock(:channel, type: 'channel')),
        4 => mock(:activity, object: mock(:channel, type: 'stream')),
        5 => mock(:activity, object: mock(:channel, type: 'channel'))
      }

      Activity.stub(:find)
              .with(action: 'added_fact_to_channel')
              .and_return mock(ids: activities_by_id.keys)
      Activity.stub(:[]) do |id|
        activities_by_id[id]
      end


      activities_by_id[2].should_receive(:delete)
      activities_by_id[4].should_receive(:delete)

      command = described_class.new
      command.call
    end
  end
end
