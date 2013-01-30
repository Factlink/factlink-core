require 'pavlov_helper'

require_relative '../../../../app/interactors/interactors/channels/add_fact'

describe Interactors::Channels::AddFact do
  describe '.call' do
    it 'correctly' do
      fact = mock(id: 1, site: mock(id: 10))
      topic = mock(id: '1e', slug_title: mock)
      channel = mock(topic: topic)
      user = mock

      described_class.any_instance.should_receive(:authorized?).and_return true

      interactor = described_class.new fact, channel

      channel.should_receive(:created_by).and_return(user)

      interactor.should_receive(:command).with(:"channels/add_fact", fact, channel)
      interactor.should_receive(:command).with(:"site/add_top_topic", fact.site.id, channel.topic.slug_title)
      interactor.should_receive(:command).with(:"create_activity", user, :added_fact_to_channel, fact, channel)

      interactor.call
    end
  end

  describe '.authorized?' do
    it 'returns the passed current_user' do
      current_user = mock
      interactor = described_class.new mock, mock, current_user: current_user

      expect(interactor.authorized?).to eq current_user
    end

    it 'returns true when the :no_current_user option is true' do
      interactor = described_class.new mock, mock, no_current_user: true

      expect(interactor.authorized?).to eq true
    end

    it 'returns false when neither :current_user or :no_current_user are passed' do
      expect(lambda { described_class.new mock, mock }).to raise_error(Pavlov::AccessDenied)
    end
  end
end
