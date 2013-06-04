require_relative '../../app/entities/dead_fact.rb'

describe DeadFact do
  describe 'initializing' do
    it "should only require the id" do
      dead_fact = DeadFact.new 1
    end
  end
  describe "#to_s" do
    it "returns the displaystring" do
      displaystring = 'displaystring'
      dead_fact = DeadFact.new 1, 'http://example.org', displaystring
      expect(dead_fact.to_s).to eq dead_fact.displaystring
    end

    it "should act as Fact for Authority.on" do
      dead_fact = DeadFact.new 1, 'http://example.org', 'displaystring'
      expect(dead_fact.acts_as_class_for_authority).to eq 'Fact'
    end
  end
end
