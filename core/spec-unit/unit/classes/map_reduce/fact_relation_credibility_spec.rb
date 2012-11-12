require 'spec_helper'

describe MapReduce::FactRelationCredibility do
  describe :authorities_on_fact_id do
    it do
      authorities = mock(:authorities)
      fact = mock(:fact, id: 20)

      Basefact.should_receive(:[]).with(fact.id).and_return(fact)
      Authority.should_receive(:all_on).with(fact).and_return(authorities)
      expect(subject.authorities_on_fact_id(fact.id)).to eq(authorities)
      expect(subject.authorities_on_fact_id(fact.id)).to eq(authorities)
    end
  end

  describe :wrapped_map do
    it do
      fact_relation = mock(:fact_relation, id: 30, fact_id: 20)
      authority = mock(:authority, user_id: 13, to_f: 57.0)
      subject.should_receive(:authorities_on_fact_id).with(20).and_return([authority])

      result = subject.wrapped_map([fact_relation]).should == {
        {user_id: 13, fact_id: 30 } => [57.0]
      }
    end
  end

  describe :reduce do
    it do
      subject.reduce(:foo, [1,2,3]).should == 2.0
    end
  end
end
