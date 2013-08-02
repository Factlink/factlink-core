require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/channels/add_facts_from_channel_to_channel'

describe Commands::Channels::AddFactsFromChannelToChannel do
  include PavlovSupport
  describe ".perform" do
    let(:nr_of_initial_facts){ described_class::NUMBER_OF_INITIAL_FACTS }

    before do
      stub_classes 'Commands::Channels::AddFactWithoutPropagation'
    end

    it "should add the fact to the cached facts of the super channel using Resque" do
      channel = double
      sub_channel = double :sub_channel,
                        sorted_internal_facts: double
      fact = double

      sub_channel.sorted_internal_facts.stub(:below)
                   .with('inf', count: nr_of_initial_facts)
                   .and_return([fact])

      Pavlov.stub(:old_command).with(:'channels/add_fact_without_propagation',
        fact, channel, nil)

      described_class.perform subchannel: sub_channel, channel: channel
    end

    it "should only add NUMBER_OF_INITIAL_FACTS facts to the super channel" do
      channel = double
      sub_channel = double :sub_channel,
                        sorted_internal_facts: double

      fact = double
      facts = Array.new(nr_of_initial_facts).map {|item| fact}
      sub_channel.sorted_internal_facts.stub(:below)
                   .with('inf', count: nr_of_initial_facts)
                   .and_return(facts)

      Pavlov.stub(:old_command).with(:'channels/add_fact_without_propagation', fact, channel, nil)
        .exactly(nr_of_initial_facts).times
        .and_return(double call: nil)

      described_class.perform subchannel: sub_channel, channel: channel
    end
  end
end
