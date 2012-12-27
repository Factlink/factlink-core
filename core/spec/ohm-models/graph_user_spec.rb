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
end
