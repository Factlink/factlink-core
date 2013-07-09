require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/facts/get_opinion.rb'

describe Queries::Facts::GetOpinion do
  include PavlovSupport

  describe '#call' do
    it 'returns the opinion on the fact' do
      opinion = mock
      fact = mock get_opinion: opinion

      query = described_class.new fact
      result = query.call

      expect(result).to eq opinion
    end
  end
end
