require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/opinions/recalculate_fact_opinion'

describe Commands::Opinions::RecalculateFactOpinion do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'Opinion::FactCalculation'
    end

    it 'calls fact.calculate_opinion(1)' do
      opinion = mock
      fact = mock
      fact_calculation = mock
      Opinion::FactCalculation.stub(:new).with(fact)
        .and_return(fact_calculation)

      fact_calculation.should_receive(:calculate_opinion).with(1)

      command = described_class.new fact
      result = command.call
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
