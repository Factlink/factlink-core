require 'pavlov_helper'

require_relative '../../../../app/interactors/interactors/channels/add_fact'

describe Interactors::Channels::AddFact do
  include PavlovSupport

  describe '#call' do
    it 'correctly' do
      fact = double(id: 1, site: double(id: 10))
      topic = double(id: '1e', slug_title: double)

      user = double :user, graph_user_id: 26
      channel = double :channel, topic: topic,
        created_by_id: user.graph_user_id,
        created_by: user

      pavlov_options = { current_user: user }
      interactor = described_class.new fact: fact, channel: channel,
        pavlov_options: pavlov_options

      Pavlov.should_receive(:command)
            .with(:"channels/add_fact", fact: fact, channel: channel, pavlov_options: pavlov_options)
      Pavlov.should_receive(:command)
            .with(:"site/add_top_topic", site_id: fact.site.id, topic_slug: channel.topic.slug_title, pavlov_options: pavlov_options)
      Pavlov.should_receive(:command)
            .with(:"create_activity", graph_user: user, action: :added_fact_to_channel, subject: fact, object: channel, pavlov_options: pavlov_options)

      interactor.call
    end
  end

  describe '.authorized?' do
    it 'returns false if the current user did not create the channel' do
    end
    it 'returns true if the current user created the channel' do
      fact = double
      user = double :user, graph_user_id: 26
      channel = double :channel, created_by_id: user.graph_user_id

      interactor = described_class.new fact: fact, channel: channel,
        pavlov_options: { current_user: user }

      expect(interactor.authorized?).to be_true
    end

    it 'returns true when the :no_current_user option is true' do
      interactor = described_class.new fact: double, channel: double,
        pavlov_options: { no_current_user: true }

      expect(interactor.authorized?).to eq true
    end

    it 'returns false when neither :current_user or :no_current_user are passed' do
      expect_validating( fact: double, channels: double )
        .to raise_error(Pavlov::AccessDenied)
    end
  end
end
