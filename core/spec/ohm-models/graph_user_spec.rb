require 'spec_helper'

describe GraphUser do
  def self.others(opinion)
    others = [:believes, :doubts, :disbelieves]
    others.delete(opinion)
    others
  end

  subject {FactoryGirl.create :graph_user }
  let(:fact) {FactoryGirl.create(:fact,:created_by => subject)}

  context "Initially" do
    context "the subjects channels" do
      it { subject.created_facts_channel.title.should == "Created" }
      it { subject.stream.title.should == "All" }
    end
  end

  [:believes, :doubts, :disbelieves].each do |type|
    context "after adding #{type} to a fact" do
      before do
        fact.add_opinion(type,subject)
      end

      it { expect(subject.has_opinion?(type,fact)).to be_true}

      others(type).each do |other_type|
        it { expect(subject.has_opinion?(other_type,fact)).to be_false}
      end
    end
  end

end
