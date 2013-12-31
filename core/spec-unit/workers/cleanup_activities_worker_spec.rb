require 'pavlov_helper'
require_relative '../../app/workers/cleanup_activities_worker.rb'

describe CleanupActivitiesWorker do
  include PavlovSupport

  describe '.perform' do
    it 'deletes invalid activities' do
      stub_classes 'Activity'
      valid_activity = double id: 1, still_valid?: true
      invalid_activity = double id: 2, still_valid?: false
      Activity.stub(all: double(ids: [valid_activity.id, invalid_activity.id]))
      Activity.stub(:[]).with(valid_activity.id).and_return(valid_activity)
      Activity.stub(:[]).with(invalid_activity.id).and_return(invalid_activity)

      expect(invalid_activity).to receive(:delete)

      described_class.perform
    end
  end
end
