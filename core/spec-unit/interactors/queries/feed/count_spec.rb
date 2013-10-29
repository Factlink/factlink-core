require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/feed/count'

describe Queries::Feed::Count do
  include PavlovSupport

  describe '#call' do
    it 'returns the count for logged in users' do
      timestamp = '0'
      count = 15

      graph_user = double stream_activities: double
      pavlov_options = {
        current_user: double(graph_user: graph_user)
      }

      query = described_class.new(timestamp: timestamp,
                                  pavlov_options: pavlov_options)

      allow(graph_user.stream_activities).to receive(:count_above)
        .with(timestamp).and_return(count)

      expect(query.call).to eq count
    end

    it 'returns zero for non-logged in users' do
      query = described_class.new(pavlov_options: {})

      expect(query.call).to eq 0
    end
  end
end
