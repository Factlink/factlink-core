require 'pavlov_helper'

require_relative '../../../../app/interactors/interactors/channels/add_fact'

describe Interactors::Channels::AddFact do
  include PavlovSupport

  describe '#call' do
    it 'correctly' do
      fact = mock(id: 1, site: mock(id: 10))
      topic = mock(id: '1e', slug_title: mock)

      user = mock :user, graph_user_id: 26
      channel = mock :channel, topic: topic, created_by_id: user.graph_user_id

      interactor = described_class.new fact: fact, channel: channel,
        pavlov_options: { current_user: user }

      channel.should_receive(:created_by).and_return(user)

      interactor.should_receive(:old_command).with(:"channels/add_fact", fact, channel)
      interactor.should_receive(:old_command).with(:"site/add_top_topic", fact.site.id, channel.topic.slug_title)
      interactor.should_receive(:old_command).with(:"create_activity", user, :added_fact_to_channel, fact, channel)

      interactor.call
    end
  end

  describe '.authorized?' do
    it 'returns false if the current user did not create the channel' do
    end
    it 'returns true if the current user created the channel' do
      fact = double
      user = mock :user, graph_user_id: 26
      channel = mock :channel, created_by_id: user.graph_user_id

      interactor = described_class.new fact: fact, channel: channel,
        pavlov_options: { current_user: user }

      expect(interactor.authorized?).to be_true
    end

    it 'returns true when the :no_current_user option is true' do
      interactor = described_class.new fact: mock, channel: mock,
        pavlov_options: { no_current_user: true }

      expect(interactor.authorized?).to eq true
    end

    it 'returns false when neither :current_user or :no_current_user are passed' do
      expect_validating( fact: mock, channels: mock )
        .to raise_error(Pavlov::AccessDenied)
    end
  end
end
