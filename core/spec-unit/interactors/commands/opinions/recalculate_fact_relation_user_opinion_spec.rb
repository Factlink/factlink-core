require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/opinions/recalculate_fact_relation_user_opinion'

describe Commands::Opinions::RecalculateFactRelationUserOpinion do
  include PavlovSupport

  describe '#call' do
    it 'calls fact_relation.calculate_user_opinion' do
      fact_relation = mock

      fact_relation.should_receive(:calculate_user_opinion)

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
