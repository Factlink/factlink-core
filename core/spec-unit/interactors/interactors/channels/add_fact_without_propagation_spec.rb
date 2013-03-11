require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/channels/add_fact_without_propagation'

describe Interactors::Channels::AddFactWithoutPropagation do
  include PavlovSupport
  describe '.call' do
    before do
      stub_classes
    end

    it 'adds the fact to the topic and the channel' do
      fact = mock(:fact, channels: mock, id: mock, created_by_id: 14)
      channel = mock :channel,
                    sorted_cached_facts: mock,
                    type: 'channel',
                    slug_title: mock,
                    created_by_id: 14
      score = mock(:score, to_s: mock)

      interactor = Interactors::Channels::AddFactWithoutPropagation.new fact, channel, score, false
      interactor.stub(should_execute?: true)

      channel.sorted_cached_facts.should_receive(:add).with(fact, score)
      fact.channels.should_receive(:add).with(channel)

      interactor.should_receive(:command).with(:"topics/add_fact",
          fact.id, channel.slug_title, score.to_s)

      expect(interactor.call).to be_true
    end

    it 'does not add the fact if the channel is no real channel' do
      fact = mock(:fact, channels: mock, id: mock, created_by_id: 14)
      channel = mock :channel,
                    sorted_cached_facts: mock,
                    type: 'notchannel',
                    slug_title: mock,
                    created_by_id: 14
      score = mock(:score, to_s: mock)

      interactor = Interactors::Channels::AddFactWithoutPropagation.new fact, channel, score, false
      interactor.stub(should_execute?: true)

      channel.sorted_cached_facts.should_receive(:add).with(fact, score)

      expect(interactor.call).to be_true
    end

    it 'adds the fact to the unread facts if it is indicated and it makes sense' do
      fact = mock(:fact, channels: mock, id: mock, created_by_id: 14)
      channel = mock :channel,
                    sorted_cached_facts: mock,
                    unread_facts: mock,
                    type: 'channel',
                    slug_title: mock,
                    created_by_id: 56 # not 14
      score = mock(:score, to_s: mock)
      channel.sorted_cached_facts.stub!(:add)
      fact.channels.stub!(:add)

      interactor = Interactors::Channels::AddFactWithoutPropagation.new fact, channel, score, true
      interactor.stub(should_execute?: true)
      interactor.stub!(:command)

      channel.unread_facts.should_receive(:add).with(fact)

      interactor.call
    end

    it "doesn't add the fact to the unread facts if the user has seen the fact because he made it" do
      fact = mock(:fact, channels: mock, id: mock, created_by_id: 14)
      channel = mock :channel,
                    sorted_cached_facts: mock,
                    unread_facts: mock,
                    type: 'channel',
                    slug_title: mock,
                    created_by_id: 14 # not 14
      score = mock(:score, to_s: mock)
      channel.sorted_cached_facts.stub!(:add)
      fact.channels.stub!(:add)

      interactor = Interactors::Channels::AddFactWithoutPropagation.new fact, channel, score, true
      interactor.stub(should_execute?: true)
      interactor.stub!(:command)

      interactor.call
    end

    it "returns false if the fact did not need to be added, or wasn't added " do
      fact = mock
      channel = mock
      score = mock

      interactor = Interactors::Channels::AddFactWithoutPropagation.new fact, channel, score, false
      interactor.stub(should_execute?: false)

      expect(interactor.call).to be_false
    end
  end
  describe 'should_execute?' do
    it "should return false if the fact is already added" do
      fact = mock
      channel = mock :channel,
                    sorted_cached_facts: mock,
                    sorted_delete_facts: mock
      score = mock

      channel.sorted_cached_facts.should_receive(:include?).any_number_of_times
                                 .with(fact).and_return(true)
      channel.sorted_delete_facts.should_receive(:include?).any_number_of_times
                                 .with(fact).and_return(false)

      interactor = Interactors::Channels::AddFactWithoutPropagation.new fact, channel, score, false

      expect(interactor.should_execute?).to be_false
    end
    it "should return false if the fact is already deleted" do
      fact = mock
      channel = mock :channel,
                    sorted_cached_facts: mock,
                    sorted_delete_facts: mock
      score = mock

      channel.sorted_cached_facts.should_receive(:include?).any_number_of_times
                                 .with(fact).and_return(false)
      channel.sorted_delete_facts.should_receive(:include?).any_number_of_times
                                 .with(fact).and_return(true)

      interactor = Interactors::Channels::AddFactWithoutPropagation.new fact, channel, score, false

      expect(interactor.should_execute?).to be_false
    end
    it "should return true in other cases" do
      fact = mock
      channel = mock :channel,
                    sorted_cached_facts: mock,
                    sorted_delete_facts: mock
      score = mock

      channel.sorted_cached_facts.should_receive(:include?).any_number_of_times
                                 .with(fact).and_return(false)
      channel.sorted_delete_facts.should_receive(:include?).any_number_of_times
                                 .with(fact).and_return(false)

      interactor = Interactors::Channels::AddFactWithoutPropagation.new fact, channel, score, false

      expect(interactor.should_execute?).to be_true
    end
  end
end
