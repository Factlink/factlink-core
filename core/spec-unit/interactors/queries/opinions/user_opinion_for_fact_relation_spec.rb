require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/opinions/user_opinion_for_fact_relation.rb'

describe Queries::Opinions::UserOpinionForFactRelation do
  include PavlovSupport

  describe '#call' do
    it 'returns fact_relation.get_user_opinion' do
      fact_relation = mock get_user_opinion: mock

      query = described_class.new fact_relation

      expect(query.call).to eq fact_relation.get_user_opinion
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      fact_relation = mock

      described_class.any_instance.should_receive(:validate_not_nil)
                                  .with(:fact_relation, fact_relation)

      query = described_class.new fact_relation
    end
  end
end
