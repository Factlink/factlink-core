require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/opinions/relevance_opinion_for_fact_relation.rb'

describe Queries::Opinions::RelevanceOpinionForFactRelation do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'Opinion::BaseFactCalculation', 'DeadOpinion'
    end

    it 'returns the opinion on the fact_relation' do
      opinion = mock
      dead_opinion = mock
      fact_relation = mock
      base_fact_calculation = mock get_user_opinion: opinion

      Opinion::BaseFactCalculation.stub(:new).with(fact_relation)
        .and_return(base_fact_calculation)

      DeadOpinion.stub(:from_opinion).with(opinion).and_return(dead_opinion)

      query = described_class.new fact_relation
      result = query.call

      expect(result).to eq dead_opinion
    end
  end
end
