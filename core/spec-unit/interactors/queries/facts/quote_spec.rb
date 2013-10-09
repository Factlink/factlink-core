require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/facts/quote.rb'

describe Queries::Facts::Quote do
  include PavlovSupport

  describe '#call' do
    it 'returns the displaystring wrapped in quotes' do
      user = double
      fact = double(displaystring: '   displaystring    ')
      fact_url = double sharing_url: 'sharing_url'
      interactor = described_class.new fact: fact, max_length: 100

      expect(interactor.call).to eq "\u201c" + "displaystring" + "\u201d"
    end

    it 'trims strings that are too long and strips whitespace also for the shorter version' do
      user = double
      fact = double(displaystring: '   12345   asdf  ')
      fact_url = double sharing_url: 'sharing_url'
      interactor = described_class.new fact: fact, max_length: 10

      expect(interactor.call).to eq "\u201c" + "12345" + "\u2026" + "\u201d"
    end
  end
end
