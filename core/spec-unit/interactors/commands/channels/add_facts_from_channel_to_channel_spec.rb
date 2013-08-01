require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/channels/add_facts_from_channel_to_channel'

describe Commands::Channels::AddFactsFromChannelToChannel do
  include PavlovSupport
  describe ".perform" do
    let(:nr_of_initial_facts){ Commands::Channels::AddFactsFromChannelToChannel::NUMBER_OF_INITIAL_FACTS }

    before do
      stub_classes 'Commands::Channels::AddFactWithoutPropagation'
    end

    it "should add the fact to the cached facts of the super channel using Resque" do
      channel = double
      sub_channel = mock :sub_channel,
                        sorted_internal_facts: mock
      fact = double

      sub_channel.sorted_internal_facts.stub(:below)
                   .with('inf', count: nr_of_initial_facts)
                   .and_return([fact])

      command = double
      Commands::Channels::AddFactWithoutPropagation.stub(:new)
           .with(fact, channel, nil).and_return(command)
      command.should_receive(:call)

      Commands::Channels::AddFactsFromChannelToChannel.perform sub_channel, channel
    end

    it "should only add NUMBER_OF_INITIAL_FACTS facts to the super channel" do
      channel = double
      sub_channel = mock :sub_channel,
                        sorted_internal_facts: mock

      facts = Array.new(nr_of_initial_facts).map {|item| mock}
      sub_channel.sorted_internal_facts.stub(:below)
                   .with('inf', count: nr_of_initial_facts)
                   .and_return(facts)

      Commands::Channels::AddFactWithoutPropagation.stub(:new)
            .exactly(nr_of_initial_facts).times
            .and_return(mock call: nil)

      Commands::Channels::AddFactsFromChannelToChannel.perform sub_channel, channel
    end
  end
end
