require 'pavlov_helper'

require_relative '../../../../app/interactors/interactors/feed/count'

describe Interactors::Feed::Count do
  include PavlovSupport

  describe '#call' do
    it 'correctly' do
      channel_id = '1'
      timestamp = '2345678'
      count = 15

      pavlov_options = {current_user: double}
      interactor = described_class.new timestamp: timestamp, pavlov_options: pavlov_options

      Pavlov.should_receive(:query)
            .with(:"feed/count", timestamp: timestamp.to_i, pavlov_options: pavlov_options)
            .and_return count

      expect(interactor.call).to eq({count: count, timestamp: timestamp.to_i})
    end
  end

  describe '.authorized?' do
    it 'returns true' do
      interactor = described_class.new
      expect(interactor.authorized?).to be_true
    end
  end
end
