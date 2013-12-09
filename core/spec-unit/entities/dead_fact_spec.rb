require_relative '../../app/entities/dead_fact.rb'

describe DeadFact do
  describe 'initializing' do
    it "should only require the id" do
      dead_fact = DeadFact.new 1
      expect(dead_fact.id).to eq 1
    end
  end
  describe "#to_s" do
    it "returns the displaystring" do
      displaystring = 'displaystring'
      dead_fact = DeadFact.new 1, 'http://example.org', displaystring
      expect(dead_fact.to_s).to eq dead_fact.displaystring
    end
  end
end
