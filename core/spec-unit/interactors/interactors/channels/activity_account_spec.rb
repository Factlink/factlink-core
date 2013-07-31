require 'pavlov_helper'

require_relative '../../../../app/interactors/interactors/channels/activity_count'

describe Interactors::Channels::ActivityCount do
  include PavlovSupport

  describe '#call' do
    it 'correctly' do
      channel_id = mock
      timestamp = mock

      described_class.any_instance.should_receive(:authorized?).and_return true
      interactor = described_class.new channel_id: channel_id,
        timestamp: timestamp

      interactor.should_receive(:old_query).with(:"channels/activity_count", channel_id, timestamp)

      interactor.call
    end
  end

  describe '.authorized?' do
    it 'returns the passed current_user' do
      current_user = mock
      interactor = described_class.new channeld_id: mock, timestamp: mock,
        pavlov_options: { current_user: current_user }

      expect(interactor.authorized?).to eq current_user
    end

    it 'returns true when the :no_current_user option is true' do
      interactor = described_class.new channel_id: mock, timestamp: mock,
        pavlov_options: { no_current_user: true }

      expect(interactor.authorized?).to eq true
    end

    it 'returns false when neither :current_user or :no_current_user are passed' do
      expect_validating( channel_id: mock, timestamp: mock )
        .to raise_error(Pavlov::AccessDenied)
    end
  end
end
