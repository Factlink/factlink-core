require 'spec_helper'

describe GraphUser do
  def self.others(opinion)
    others = [:believes, :doubts, :disbelieves]
    others.delete(opinion)
    others
  end

  subject { create :graph_user }
  let(:fact) { create(:fact, created_by: subject) }

  context "Initially" do
    context "the subjects channels" do
      it { subject.created_facts_channel.title.should == "Created" }
    end
  end
end
