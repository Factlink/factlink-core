require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/channels/add_fact_without_propagation'

describe Interactors::Channels::AddFactWithoutPropagation do
  include PavlovSupport

  describe '.call' do
    it 'adds the fact to the topic and the channel' do
      fact = mock :fact,
                 id: mock,
                 created_by_id: 14
      channel = mock :channel,
                    type: 'channel',
                    slug_title: mock,
                    created_by_id: fact.created_by_id()
      score = mock(:score, to_s: mock)

      interactor = described_class.new fact: fact, channel: channel, score: score,
        should_add_to_unread: false

      interactor.should_receive(:old_command).with(:"channels/add_fact_without_propagation",
          fact, channel, score).and_return true

      interactor.should_receive(:old_command).with(:"topics/add_fact",
          fact.id, channel.slug_title, score.to_s)

      expect(interactor.call).to be_true
    end

    it 'does not add the fact to a topic if the channel is no real channel' do
      fact = mock :fact,
                 id: mock,
                 created_by_id: 14
      channel = mock :channel,
                    type: 'notchannel',
                    slug_title: mock,
                    created_by_id: fact.created_by_id + 1
      score = mock(:score, to_s: mock)

      interactor = described_class.new fact: fact, channel: channel, score: score,
        should_add_to_unread: false
      interactor.should_receive(:old_command).with(:"channels/add_fact_without_propagation",
          fact, channel, score).and_return true

      expect(interactor.call).to be_true
    end

    it 'adds the fact to the unread facts if it is indicated and it makes sense' do
      fact = mock :fact,
                 id: mock,
                 created_by_id: 14
      channel = mock :channel,
                    unread_facts: mock,
                    type: 'channel',
                    slug_title: mock,
                    created_by_id: fact.created_by_id + 1
      score = mock(:score, to_s: mock)

      interactor = described_class.new fact: fact, channel: channel, score: score,
        should_add_to_unread: true

      Pavlov.should_receive(:old_command).with(:"channels/add_fact_without_propagation",
          fact, channel, score).and_return true
      Pavlov.should_receive(:old_command).with(:"topics/add_fact",
          fact.id, channel.slug_title, score.to_s)

      interactor.stub!(:command)

      channel.unread_facts.should_receive(:add).with(fact)

      interactor.call
    end

    it "doesn't add the fact to the unread facts if the user has seen the fact because he made it" do
      fact = mock :fact,
                 id: mock,
                 created_by_id: 14
      channel = mock :channel,
                    unread_facts: mock,
                    type: 'channel',
                    slug_title: mock,
                    created_by_id: fact.created_by_id
      score = mock(:score, to_s: mock)

      interactor = described_class.new fact: fact, channel: channel, score: score,
        should_add_to_unread: true
      interactor.should_receive(:old_command).with(:"channels/add_fact_without_propagation",
          fact, channel, score).and_return false

      interactor.call
    end

    it "returns false if the fact did not need to be added, or wasn't added " do
      fact, channel, score = mock, mock, mock

      interactor = described_class.new fact: fact, channel: channel, score: score,
        should_add_to_unread: false
      interactor.should_receive(:old_command).with(:"channels/add_fact_without_propagation",
          fact, channel, score).and_return false

      expect(interactor.call).to be_false
    end
  end
end
