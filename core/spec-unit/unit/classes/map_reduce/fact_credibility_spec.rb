require 'spec_helper'

describe MapReduce::FactCredibility do
  describe :authorities_from_topic do
    it do
      authorities = mock(:authorities)
      topic = mock(:topic, id: 10)

      Authority.should_receive(:all_from).with(topic).and_return(authorities)
      expect(subject.authorities_from_topic(topic)).to eq(authorities)
      expect(subject.authorities_from_topic(topic)).to eq(authorities)
    end
  end

  describe :wrapped_map do
    it do
      facts = mock(:facts, ids: [20])
      ch1 = mock(:channel, sorted_cached_facts: facts, topic: mock())

      authority = mock(:authority, user_id: 13, to_f: 57.0)
      subject.should_receive(:authorities_from_topic).with(ch1.topic).and_return([authority])

      result = subject.wrapped_map([ch1]).should == {
        {user_id: 13, fact_id: 20 } => [57.0]
      }
    end
  end

  describe :reduce do
    it do
      subject.reduce(:foo, [1,2,3]).should == 2.0
    end
  end
end
