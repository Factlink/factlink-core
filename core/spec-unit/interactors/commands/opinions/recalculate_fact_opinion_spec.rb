require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/opinions/recalculate_fact_opinion'

describe Commands::Opinions::RecalculateFactOpinion do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'FactGraph'
    end

    it 'calls fact.calculate_opinion(1)' do
      opinion = double
      fact = double
      fact_graph = double
      command = described_class.new fact: fact

      FactGraph.stub new: fact_graph

      fact_graph.should_receive(:calculate_fact_when_user_opinion_changed)
        .with(fact)

      command.call
    end
  end

  describe 'validation' do
    it 'without fact_id doesn\'t validate' do
      expect_validating(fact: nil)
        .to fail_validation('fact should not be nil.')
    end
  end
end
