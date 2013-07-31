require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/channels/add_fact_without_propagation'

describe Commands::Channels::AddFactWithoutPropagation do
  include PavlovSupport
  describe '#call' do
    it 'adds the fact to the channel, and the channel to the fact' do
      fact = mock :fact,
                 channels: mock,
                 id: mock,
                 created_by_id: 14
      channel = mock :channel,
                    sorted_cached_facts: mock,
                    type: 'channel',
                    slug_title: mock,
                    created_by_id: 14
      score = mock(:score, to_s: mock)

      command = described_class.new fact: fact,
        channel: channel, score: score
      command.stub(should_execute?: true)

      channel.sorted_cached_facts.should_receive(:add).with(fact, score)
      fact.channels.should_receive(:add).with(channel)

      expect(command.call).to be_true
    end
    it 'adds the fact to the channel, but not the channel to the fact, when the channel is not a regular channel' do
      fact = mock :fact,
                 channels: mock,
                 id: mock,
                 created_by_id: 14
      channel = mock :channel,
                    sorted_cached_facts: mock,
                    type: 'notchannel',
                    slug_title: mock,
                    created_by_id: 14
      score = mock(:score, to_s: mock)

      command = described_class.new fact: fact,
        channel: channel, score: score
      command.stub(should_execute?: true)

      channel.sorted_cached_facts.should_receive(:add).with(fact, score)
      fact.channels.should_not_receive(:add).with(channel)

      expect(command.call).to be_true
    end
    it "returns false if the fact did not need to be added, or wasn't added " do
      command = described_class.new fact: mock,
        channel: mock, score: mock
      command.stub(should_execute?: false)

      expect(command.call).to be_false
    end
  end
  describe 'should_execute?' do
    it "should return false if the fact is already added" do
      fact, score = mock, mock
      channel = mock :channel,
                    sorted_cached_facts: mock,
                    sorted_delete_facts: mock

      channel.sorted_cached_facts.stub(:include?).with(fact).and_return(true)
      channel.sorted_delete_facts.stub(:include?).with(fact).and_return(false)

      command = described_class.new fact: fact,
        channel: channel, score: score

      expect(command.should_execute?).to be_false
    end
    it "should return false if the fact is already deleted" do
      fact, score = mock, mock
      channel = mock :channel,
                    sorted_cached_facts: mock,
                    sorted_delete_facts: mock

      channel.sorted_cached_facts.stub(:include?).with(fact).and_return(false)
      channel.sorted_delete_facts.stub(:include?).with(fact).and_return(true)

      command = described_class.new fact: fact,
        channel: channel, score: score

      expect(command.should_execute?).to be_false
    end
    it "should return true in other cases" do
      fact, score = mock, mock
      channel = mock :channel,
                    sorted_cached_facts: mock,
                    sorted_delete_facts: mock

      channel.sorted_cached_facts.stub(:include?).with(fact).and_return(false)
      channel.sorted_delete_facts.stub(:include?).with(fact).and_return(false)

      command = described_class.new fact: fact,
        channel: channel, score: score

      expect(command.should_execute?).to be_true
    end
  end
end
