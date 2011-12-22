require 'spec_helper'

describe GraphUser do

  subject {FactoryGirl.create :graph_user }
  let(:fact) {FactoryGirl.create(:fact,:created_by => subject)}

  context "Initially" do
    it { subject.facts.to_a.should == [] }
    it { subject.facts_he(:believes).should be_empty }
    it { subject.facts_he(:doubts).should be_empty }
    it { subject.facts_he(:disbelieves).should be_empty }
    it { GraphUser.top(10).to_a =~ []}
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
