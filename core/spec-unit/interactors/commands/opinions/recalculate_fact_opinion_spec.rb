require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/opinions/recalculate_fact_opinion'

describe Commands::Opinions::RecalculateFactOpinion do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'FactGraph'
    end

    it 'calls fact.calculate_opinion(1)' do
      opinion = mock
      fact = mock
      fact_graph = mock
      command = described_class.new fact

      FactGraph.stub new: fact_graph

      fact_graph.should_receive(:calculate_fact_when_user_opinion_changed)
        .with(fact)

      command.call
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      fact = mock

      described_class.any_instance.should_receive(:validate_not_nil)
                                  .with(:fact, fact)

      command = described_class.new fact
    end
  end
end
