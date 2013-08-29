require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/channels/add_fact_without_propagation'

describe Interactors::Channels::AddFactWithoutPropagation do
  include PavlovSupport

  describe '#call' do
    it 'adds the fact to the topic and the channel' do
      fact = double :fact,
                 id: double,
                 created_by_id: 14
      channel = double :channel,
                    type: 'channel',
                    slug_title: double,
                    created_by_id: fact.created_by_id
      score = double(:score, to_s: double)

      interactor = described_class.new fact: fact, channel: channel, score: score,
        should_add_to_unread: false

      Pavlov.should_receive(:command)
            .with(:"channels/add_fact_without_propagation", fact: fact, channel: channel, score: score)
            .and_return true

      Pavlov.should_receive(:command)
            .with(:"topics/add_fact", fact_id: fact.id, topic_slug_title: channel.slug_title, score: score.to_s)

      expect(interactor.call).to be_true
    end

    it 'does not add the fact to a topic if the channel is no real channel' do
      fact = double :fact,
                 id: double,
                 created_by_id: 14
      channel = double :channel,
                    type: 'notchannel',
                    slug_title: double,
                    created_by_id: fact.created_by_id + 1
      score = double(:score, to_s: double)

      interactor = described_class.new fact: fact, channel: channel, score: score,
        should_add_to_unread: false

      Pavlov.should_receive(:command)
            .with(:"channels/add_fact_without_propagation", fact: fact, channel: channel, score: score)
            .and_return true

      expect(interactor.call).to be_true
    end

    it 'adds the fact to the unread facts if it is indicated and it makes sense' do
      fact = double :fact,
                 id: double,
                 created_by_id: 14
      channel = double :channel,
                    unread_facts: double,
                    type: 'channel',
                    slug_title: double,
                    created_by_id: fact.created_by_id + 1
      score = double(:score, to_s: double)

      interactor = described_class.new fact: fact, channel: channel, score: score,
        should_add_to_unread: true

      Pavlov.should_receive(:command)
            .with(:"channels/add_fact_without_propagation", fact: fact, channel: channel, score: score)
            .and_return true
      Pavlov.should_receive(:command)
            .with(:"topics/add_fact", fact_id: fact.id, topic_slug_title: channel.slug_title, score: score.to_s)

      channel.unread_facts.should_receive(:add).with(fact)

      interactor.call
    end

    it "doesn't add the fact to the unread facts if the user has seen the fact because he made it" do
      fact = double :fact,
                 id: double,
                 created_by_id: 14
      channel = double :channel,
                    unread_facts: double,
                    type: 'channel',
                    slug_title: double,
                    created_by_id: fact.created_by_id
      score = double(:score, to_s: double)

      interactor = described_class.new fact: fact, channel: channel, score: score,
        should_add_to_unread: true
      Pavlov.should_receive(:command)
            .with(:"channels/add_fact_without_propagation", fact: fact, channel: channel, score: score)
            .and_return false

      interactor.call
    end

    it "returns false if the fact did not need to be added, or wasn't added " do
      fact, channel, score = double, double, double

      interactor = described_class.new fact: fact, channel: channel, score: score,
        should_add_to_unread: false
      Pavlov.should_receive(:command)
            .with(:"channels/add_fact_without_propagation", fact: fact, channel: channel, score: score)
            .and_return false

      expect(interactor.call).to be_false
    end
  end
end
