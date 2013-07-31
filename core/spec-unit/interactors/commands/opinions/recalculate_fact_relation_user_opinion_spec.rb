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

      command = described_class.new fact_relation: fact_relation
      result = command.call
    end
  end

  describe 'validation' do
    it 'without fact_relation doesn\'t validate' do
      expect_validating({fact_relation: nil}).
        to fail_validation('fact_relation should not be nil.')
    end
  end
end
