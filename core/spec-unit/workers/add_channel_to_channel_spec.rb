require 'pavlov_helper'
require_relative '../../app/workers/add_channel_to_channel'

describe AddChannelToChannel do
  include PavlovSupport
  describe ".perform" do
    let(:nr_of_initial_facts){ AddChannelToChannel::NUMBER_OF_INITIAL_FACTS }

    before do
      stub_classes 'Commands::Channels::AddFactWithoutPropagation'
    end

    it "should add the fact to the cached facts of the super channel using Resque" do
      channel = mock
      sub_channel = mock :sub_channel,
                        sorted_internal_facts: mock
      fact = mock

      sub_channel.sorted_internal_facts.stub(:below)
                   .with('inf', count: nr_of_initial_facts)
                   .and_return([fact])

      command = mock
      Commands::Channels::AddFactWithoutPropagation.stub(:new)
           .with(fact, channel, nil).and_return(command)
      command.should_receive(:call)

      AddChannelToChannel.perform sub_channel, channel
    end

    it "should only add NUMBER_OF_INITIAL_FACTS facts to the super channel" do
      channel = mock
      sub_channel = mock :sub_channel,
                        sorted_internal_facts: mock

      facts = Array.new(nr_of_initial_facts).map {|item| mock}
      sub_channel.sorted_internal_facts.stub(:below)
                   .with('inf', count: nr_of_initial_facts)
                   .and_return(facts)

      Commands::Channels::AddFactWithoutPropagation.stub(:new)
            .exactly(nr_of_initial_facts).times
            .and_return(mock call: nil)

      AddChannelToChannel.perform sub_channel, channel
    end
  end
end
