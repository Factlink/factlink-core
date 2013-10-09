require 'pavlov_helper'
require_relative '../../app/classes/fact_quote.rb'

describe FactQuote do
  include PavlovSupport

  describe '#trimmed_quote' do
    it 'returns the displaystring wrapped in quotes' do
      fact = double(displaystring: '   displaystring    ')
      fact_quote = described_class.new fact

      expect(fact_quote.trimmed_quote(100)).to eq "\u201c" + "displaystring" + "\u201d"
    end

    it 'trims strings that are too long and strips whitespace also for the shorter version' do
      fact = double(displaystring: '   12345   asdf  ')
      fact_quote = described_class.new fact

      expect(fact_quote.trimmed_quote(10)).to eq "\u201c" + "12345" + "\u2026" + "\u201d"
    end
  end
end
