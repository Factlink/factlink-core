require 'pavlov_helper'

require_relative '../../../../app/interactors/commands/activities/clean_list'

describe Commands::Activities::CleanList do
  include PavlovSupport
  before do
    stub_classes 'Activity', 'Nest'
  end

  describe '.call' do
    it 'should delete nil activities' do
      key, keyname = mock, mock
      nil_activity = nil
      activities_by_id = {
        1 => nil_activity,
        2 => mock(:activity)
      }

      Activity.stub(:[]) do |id|
        activities_by_id[id]
      end
      Nest.stub(:new).with(keyname).and_return(key)
      key.stub(:zrange).with(0,-1)
         .and_return(activities_by_id.keys)

      key.should_receive(:zrem)
         .with activities_by_id.key(nil_activity)

      command = described_class.new keyname
      command.call
    end
  end
end
