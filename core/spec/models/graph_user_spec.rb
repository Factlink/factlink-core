require 'spec_helper'

describe GraphUser do

  subject {FactoryGirl.create(:user).graph_user}
  let(:fact) {FactoryGirl.create(:fact)}

  context "Initially" do
    its(:facts) { should == [] }
    it { subject.facts_he(:beliefs).should be_empty }
    it { subject.facts_he(:doubts).should be_empty }
    it { subject.facts_he(:disbeliefs).should be_empty }
  end


  [:beliefs,:doubts,:disbeliefs].each do |type|
    context "after adding #{type} to a fact" do
      before do
        fact.add_opinion(type,subject)
      end
      it {subject.facts_he(type).all.should =~ [fact]}
      it {subject.has_opinion?(type,fact) == true}
    end
  end
end
