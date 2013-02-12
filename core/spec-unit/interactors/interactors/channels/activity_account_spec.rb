require 'pavlov_helper'

require_relative '../../../../app/interactors/interactors/channels/activity_count'

describe Interactors::Channels::ActivityCount do
  describe '.call' do
    it 'correctly' do
      channel_id = mock
      timestamp = mock

      Interactors::Channels::ActivityCount.any_instance.should_receive(:authorized?).and_return true
      interactor = Interactors::Channels::ActivityCount.new channel_id, timestamp

      interactor.should_receive(:query).with(:"channels/activity_count", channel_id, timestamp)

      interactor.call
    end
  end

  describe '.authorized?' do
    it 'returns the passed current_user' do
      current_user = mock
      interactor = Interactors::Channels::ActivityCount.new mock, mock, current_user: current_user

      expect(interactor.authorized?).to eq current_user
    end

    it 'returns true when the :no_current_user option is true' do
      interactor = Interactors::Channels::ActivityCount.new mock, mock, no_current_user: true

      expect(interactor.authorized?).to eq true
    end

    it 'returns false when neither :current_user or :no_current_user are passed' do
      expect(lambda { Interactors::Channels::ActivityCount.new mock, mock }).to raise_error(Pavlov::AccessDenied)
    end
  end
end
