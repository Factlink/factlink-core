require 'spec_helper'

describe GraphUser do

  subject {FactoryGirl.create :graph_user }
  let(:fact) {FactoryGirl.create(:fact,:created_by => subject)}

  describe "delegates" do
    it { should respond_to(:editable_channels) }
  end

  context "Initially" do
    it { subject.facts.to_a.should == [] }
    it { subject.facts_he(:believes).should be_empty }
    it { subject.facts_he(:doubts).should be_empty }
    it { subject.facts_he(:disbelieves).should be_empty }
    
    context "the subjects channels" do
      it { subject.created_facts_channel.title.should == "Created" }
      it { subject.stream.title.should == "All" }
    end
    it { GraphUser.top(10).to_a =~ []}
  end

  describe "removing a channel" do
    it "should be removed from the graph_users channels" do
      u1 = create :graph_user
      ch1 = create :channel, created_by: u1
      u1.internal_channels.should include(ch1)
      u1.channels.should include(ch1)
      ch1.real_delete
      u1 = GraphUser[u1.id]
      u1.internal_channels.should_not include(ch1)
      u1.channels.should_not include(ch1)
    end
  end

  [:believes,:doubts,:disbelieves].each do |type|
    context "after adding #{type} to a fact" do
      before do
        fact.add_opinion(type,subject)
      end
      it {subject.facts_he(type).all.should =~ [fact]}
      it {subject.has_opinion?(type,fact) == true}
      it do
        subject.channels.each do |ch|
          ch.should be_a Channel
        end
      end
    end
  end
end
