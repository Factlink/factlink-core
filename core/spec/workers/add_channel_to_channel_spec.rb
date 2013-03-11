require 'spec_helper'

describe AddChannelToChannel do
  describe ".perform" do
    let (:channel)    { create :channel }
    let(:sub_channel) { create :channel }

    it "should add the fact to the cached facts of the super channel using Resque" do
      fact = create :fact
      sub_channel.sorted_cached_facts << fact

      Fact.should_receive(:[]).with(fact.id)
           .and_return(fact)

      interactor = mock
      Interactors::Channels::AddFactWithoutPropagation.should_receive(:new)
           .with(fact, channel, nil, true).and_return(interactor)
      interactor.should_receive(:call)

      AddChannelToChannel.perform sub_channel, channel
    end

    it "should only add NUMBER_OF_INITIAL_FACTS facts to the super channel" do
      oldest_fact = create :fact
      sub_channel.sorted_cached_facts << oldest_fact

      facts = []

      AddChannelToChannel::NUMBER_OF_INITIAL_FACTS.times do |i|
        facts[i] = create :fact
        sub_channel.sorted_cached_facts << facts[i]
      end

      Interactors::Channels::AddFactWithoutPropagation.should_receive(:new)
            .exactly(AddChannelToChannel::NUMBER_OF_INITIAL_FACTS)
            .times
            .and_return(mock call: nil)

      AddChannelToChannel.perform sub_channel, channel
    end
  end
end
