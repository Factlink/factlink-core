require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/opinions/relevance_opinion_for_fact_relation.rb'

describe Queries::Opinions::RelevanceOpinionForFactRelation do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'Opinion::BaseFactCalculation'
    end

    it 'returns the dead opinion on the fact_relation' do
      dead_opinion = mock
      fact_relation = mock
      base_fact_calculation = mock get_user_opinion: dead_opinion

      Opinion::BaseFactCalculation.stub(:new).with(fact_relation)
        .and_return(base_fact_calculation)

      query = described_class.new fact_relation
      result = query.call

      expect(result).to eq dead_opinion
    end
  end
end
