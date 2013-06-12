require 'pavlov_helper'
describe MapReduce::FactRelationCredibility do
  include PavlovSupport

  before do
    stub_classes 'Basefact', 'Authority', 'FactRelation'
  end

  describe "#authorities_on_fact_id" do
    it do
      authorities = mock(:authorities)
      fact = mock(:fact, id: 20)

      Basefact.should_receive(:[]).with(fact.id).and_return(fact)
      Authority.should_receive(:all_on).with(fact).and_return(authorities)

      expect(subject.authorities_on_fact_id(fact.id)).to eq(authorities)
      expect(subject.authorities_on_fact_id(fact.id)).to eq(authorities)
    end
  end

  describe "#wrapped_map" do
    it do
      fact_relation_all = mock ids: [30]

      fact_relation = mock(:fact_relation, id: 30, fact_id: 20)
      authority = mock(:authority, user_id: 13, to_f: 57.0)
      subject.should_receive(:authorities_on_fact_id).with(20).and_return([authority])

      FactRelation.stub(:[]).with(30)
                  .and_return(fact_relation)

      result = subject.wrapped_map(fact_relation_all)
      expect(result).to eq({
        {fact_id: fact_relation.id, user_id: 13} => [57.0]
      })
    end
  end

  describe "#reduce" do
    it do
      expect(subject.reduce(:foo, [2.0])).to eq 2.0
    end
  end
end
