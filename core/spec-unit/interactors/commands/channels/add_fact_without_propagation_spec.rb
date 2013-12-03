require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/channels/add_fact_without_propagation'

describe Commands::Channels::AddFactWithoutPropagation do
  include PavlovSupport
  describe '#call' do
    it 'adds the fact to the channel, and the channel to the fact' do
      fact = double :fact,
                 channels: double,
                 id: double,
                 created_by_id: 14
      channel = double :channel,
                    sorted_internal_facts: double,
                    slug_title: double,
                    created_by_id: 14
      score = double(:score, to_s: double)

      command = described_class.new fact: fact,
        channel: channel, score: score

      fact.channels.should_receive(:add).with(channel)

      expect(command.call).to be_true
    end
  end
end
