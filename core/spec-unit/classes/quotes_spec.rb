require 'pavlov_helper'
require_relative '../../app/classes/quotes.rb'

describe Quotes do
  include PavlovSupport

  describe '#trimmed_quote' do
    it 'returns the string wrapped in quotes' do
      fact_quote = described_class.new '   displaystring    '

      expect(fact_quote.trimmed_quote(100)).to eq "\u201c" + "displaystring" + "\u201d"
    end

    it 'trims strings that are too long and strips whitespace also for the shorter version' do
      fact_quote = described_class.new '   12345   asdf  '

      expect(fact_quote.trimmed_quote(10)).to eq "\u201c" + "12345" + "\u2026" + "\u201d"
    end
  end
end
