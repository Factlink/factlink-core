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

  describe :authorities_from_channel do
    it do
      authorities = mock(:authorities)
      channel = mock(:channel, id: 10, topic: mock())

      subject.should_receive(:authorities_from_topic).with(channel.topic).and_return(authorities)
      expect(subject.authorities_from_channel(channel)).to eq(authorities)
      expect(subject.authorities_from_channel(channel)).to eq(authorities)
    end
  end

  describe :wrapped_map do
    it do
      ch1 = mock()
      facts = mock(:facts, ids: [20])
      ch1.should_receive(:sorted_cached_facts).and_return(facts)

      authority = mock(:authority, user_id: 13, to_f: 57.0)
      subject.should_receive(:authorities_from_channel).with(ch1).and_return([authority])

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
