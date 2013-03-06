require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/channels/add_fact_without_propagation'

describe Interactors::Channels::AddFactWithoutPropagation do
  include PavlovSupport
  describe '.call' do
    before do
      stub_classes
    end

    it 'correctly' do
      fact = mock(:fact, channels: mock)
      channel = mock(:channel, sorted_cached_facts: mock, type: 'channel')
      score = mock

      interactor = Interactors::Channels::AddFactWithoutPropagation.new fact, channel, score

      channel.sorted_cached_facts.should_receive(:add).with(fact, score)
      fact.channels.should_receive(:add).with(channel)

      interactor.call
    end
  end
end
