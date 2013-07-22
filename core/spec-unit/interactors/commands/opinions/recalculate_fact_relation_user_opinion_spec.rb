require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/opinions/recalculate_fact_relation_user_opinion'

describe Commands::Opinions::RecalculateFactRelationUserOpinion do
  include PavlovSupport

  describe '#call' do
    it 'calls fact_relation.calculate_user_opinion' do
      fact_relation = mock

      fact_relation.should_receive(:calculate_user_opinion)

      command = described_class.new fact_relation
      result = command.call
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      fact_relation = mock

      described_class.any_instance.should_receive(:validate_not_nil)
                                  .with(:fact_relation, fact_relation)

      command = described_class.new fact_relation
    end
  end
end
