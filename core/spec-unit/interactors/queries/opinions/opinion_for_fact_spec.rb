require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/opinions/opinion_for_fact.rb'

describe Queries::Opinions::OpinionForFact do
  include PavlovSupport

  describe '#call' do
    it 'returns the dead user opinion on the fact' do
      dead_opinion = double
      fact = double(id: double, believable: double(dead_opinion: dead_opinion))
      query = described_class.new fact: fact

      expect(query.call).to eq dead_opinion
    end
  end
end
