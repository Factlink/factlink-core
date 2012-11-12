require 'spec_helper'

describe MapReduce::FactCredibility do
  let(:gu1) {GraphUser.create}
  let(:gu2) {GraphUser.create}

  before do
    unless defined?(GraphUser)
      class GraphUser < OurOhm; end
    end
    unless defined?(Channel)
      class Channel < OurOhm;
        attribute :title
        reference :created_by, GraphUser
      end
    end
    unless defined?(Fact)
      class Fact < OurOhm;
        reference :created_by, GraphUser
      end
    end
  end

  describe :wrapped_map do
    it do
      ch1 = Channel.create(title: "Ruby", created_by: gu1)
      ruby_t = Topic.by_title "Ruby"
      ruby_t.save
      fact = Fact.create created_by: gu1
      ch1.stub!(:facts).and_return([fact])

      Authority.from(ruby_t, for: gu1) << 57

      result = subject.wrapped_map([ch1]).should == {
        {user_id: gu1.id, fact_id: fact.id } => [57.0]
      }
    end
  end
  describe :reduce do
    it do
      subject.reduce(:foo, [1,2,3]).should == 2.0
    end
  end
end
