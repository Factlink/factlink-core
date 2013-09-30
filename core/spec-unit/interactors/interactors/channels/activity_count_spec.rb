require 'pavlov_helper'

require_relative '../../../../app/interactors/interactors/channels/activity_count'

describe Interactors::Channels::ActivityCount do
  include PavlovSupport

  describe '#call' do
    it 'correctly' do
      channel_id = double
      timestamp = double
      count = double

      described_class.any_instance.should_receive(:authorized?).and_return true
      interactor = described_class.new channel_id: channel_id,
        timestamp: timestamp

      Pavlov.should_receive(:query)
            .with(:"channels/activity_count", channel_id: channel_id, timestamp: timestamp)
            .and_return count

      expect(interactor.call).to eq count
    end
  end

  describe '.authorized?' do
    it 'returns the passed current_user' do
      current_user = double
      interactor = described_class.new channeld_id: double, timestamp: double,
        pavlov_options: { current_user: current_user }

      expect(interactor.authorized?).to eq current_user
    end

    it 'returns true when the :no_current_user option is true' do
      interactor = described_class.new channel_id: double, timestamp: double,
        pavlov_options: { no_current_user: true }

      expect(interactor.authorized?).to eq true
    end

    it 'returns false when neither :current_user or :no_current_user are passed' do
      expect do
        interactor = described_class.new(channel_id: double, timestamp: double)
        interactor.call
      end.to raise_error(Pavlov::AccessDenied)
    end
  end
end
