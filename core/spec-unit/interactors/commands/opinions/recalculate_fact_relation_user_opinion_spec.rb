require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/opinions/recalculate_fact_relation_user_opinion'

describe Commands::Opinions::RecalculateFactRelationUserOpinion do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'FactGraph'
    end

    it 'calls calculate_fact_relation_when_user_opinion_changed' do
      fact_relation = double
      fact_graph = double

      FactGraph.stub new: fact_graph

      fact_graph.should_receive(:calculate_fact_relation_when_user_opinion_changed)
        .with(fact_relation)

      command = described_class.new fact_relation
      result = command.call
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      fact_relation = double

      described_class.any_instance.should_receive(:validate_not_nil)
                                  .with(:fact_relation, fact_relation)

      command = described_class.new fact_relation
    end
  end
end
