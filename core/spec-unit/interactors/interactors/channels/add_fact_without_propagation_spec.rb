require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/channels/add_fact_without_propagation'

describe Interactors::Channels::AddFactWithoutPropagation do
  include PavlovSupport

  describe '#call' do
    it 'adds the fact to the topic and the channel' do
      fact = double :fact,
                 id: double,
                 created_by_id: 14,
                 channels: double
      channel = double :channel,
                    slug_title: double,
                    created_by_id: fact.created_by_id
      score = double(:score, to_s: double)

      interactor = described_class.new fact: fact, channel: channel, score: score

      fact.channels.should_receive(:add).with(channel)
      Pavlov.should_receive(:command)
            .with(:"topics/add_fact", fact_id: fact.id, topic_slug_title: channel.slug_title, score: score.to_s)

      expect(interactor.call).to be_true
    end
  end
end
