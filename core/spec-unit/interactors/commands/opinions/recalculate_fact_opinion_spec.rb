require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/opinions/recalculate_fact_opinion'

describe Commands::Opinions::RecalculateFactOpinion do
  include PavlovSupport

  describe '#call' do
    it 'calls fact.calculate_opinion(1)' do
      fact = mock

      fact.should_receive(:calculate_opinion).with(1)

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
