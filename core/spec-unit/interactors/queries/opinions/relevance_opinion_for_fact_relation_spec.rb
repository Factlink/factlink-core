require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/opinions/relevance_opinion_for_fact_relation.rb'

describe Queries::Opinions::RelevanceOpinionForFactRelation do
  include PavlovSupport

  describe '#call' do
    it 'returns the opinion on the fact_relation' do
      opinion = mock
      fact_relation = mock get_user_opinion: opinion

      query = described_class.new fact_relation
      result = query.call

      expect(result).to eq opinion
    end
  end
end
