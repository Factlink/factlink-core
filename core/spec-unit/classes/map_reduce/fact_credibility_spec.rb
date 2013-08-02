require 'pavlov_helper'

describe MapReduce::FactCredibility do
  include PavlovSupport
  before do
    stub_classes 'Authority'
  end

  describe "#authorities_from_topic" do
    it do
      authorities = double(:authorities)
      topic = double(:topic, id: 10)

      Authority.stub(:all_from)
               .with(topic)
               .and_return(authorities)
      expect(subject.authorities_from_topic(topic))
        .to eq(authorities)
      expect(subject.authorities_from_topic(topic))
        .to eq(authorities)
    end
  end

  describe "#wrapped_map" do
    it do
      facts = double :facts,
        ids: [20]
      ch1 = double :channel,
              sorted_cached_facts: facts,
              topic: double

      authority = double :authority,
                    user_id: 13,
                    to_f: 57.0

      subject.stub(:authorities_from_topic)
             .with(ch1.topic)
             .and_return([authority])

      result = subject.wrapped_map([ch1])
      expect(result).to eq({{graph_user_id: 13, fact_id: 20 } => [57.0]})
    end
  end

  describe "#reduce" do
    it do
      expect(subject.reduce(:foo, [1,2,3])).to eq 2.0
    end
  end
end
