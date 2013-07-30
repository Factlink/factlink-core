require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/opinions/recalculate_fact_opinion'

describe Commands::Opinions::RecalculateFactOpinion do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'Opinion::FactCalculation', 'Opinion::BaseFactCalculation'
    end

    it 'calls fact.calculate_opinion(1)' do
      opinion = mock
      fact = mock
      base_fact_calculation = mock
      fact_calculation = mock

      Opinion::BaseFactCalculation.stub(:new).with(fact)
        .and_return(base_fact_calculation)
      Opinion::FactCalculation.stub(:new).with(fact)
        .and_return(fact_calculation)

      base_fact_calculation.should_receive(:calculate_user_opinion)
      fact_calculation.should_receive(:calculate_opinion)

      command = described_class.new fact: fact
      result = command.call
    end
  end

  describe 'validation' do
    it 'without fact_id doesn\'t validate' do
      expect_validating(fact: nil)
        .to fail_validation('fact should not be nil.')
    end
  end
end
