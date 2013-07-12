require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/fact_relations/relevance_opinion.rb'

describe Queries::FactRelations::RelevanceOpinion do
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
