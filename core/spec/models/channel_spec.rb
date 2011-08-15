require 'spec_helper'

describe Channel do
  subject {Channel.create(:created_by => u1, :title => "Subject")}

  let(:u1) { FactoryGirl.create(:user).graph_user }
  let(:u2) { FactoryGirl.create(:user).graph_user }
  let(:u3) { FactoryGirl.create(:user).graph_user }
  
  let (:f1) {FactoryGirl.create(:fact) }
  let (:f2) {FactoryGirl.create(:fact) }
  let (:f3) {FactoryGirl.create(:fact) }
  let (:f4) {FactoryGirl.create(:fact) }
  
  describe "initially" do
    it { subject.facts.to_a.should =~ []}
  end  
  
  describe "after adding one fact" do
    before do
      subject.add_fact(f1)
    end
    it { subject.facts.to_a.should =~ [f1]}
    describe "and removing an fact" do
      before do
        subject.remove_fact(f1)
      end
      it { subject.facts.to_a.should =~ []}
    end
    describe "after forking" do
      before { @fork = subject.fork(u2) }
      it {subject.facts.to_a.should =~ [f1]}
      it {@fork.facts.to_a.should =~ [f1]}
      
      describe "and removing the fact from the original" do
        before { subject.remove_fact(f1)}
        it {subject.facts.to_a.should =~ []}
        it {@fork.facts.to_a.should =~ []}
      end
      describe "and removing the fact from the fork" do
        before { @fork.remove_fact(f1)}
        it {subject.facts.to_a.should =~ [f1]}
        it {@fork.facts.to_a.should =~ []}
      end
      describe "after adding another fact to the original" do
        before { subject.add_fact(f2)}
        it {subject.facts.to_a.should =~ [f1,f2]}
        it {@fork.facts.to_a.should =~ [f1,f2]}
      end
      describe "after adding another fact to the fork" do
        before { @fork.add_fact(f2)}
        it {subject.facts.to_a.should =~ [f1]}
        it {@fork.facts.to_a.should =~ [f1,f2]}
      end
    end
    describe "forking the channel yourself" do
      before {@fork = subject.fork(u1) }
      it "should have a different title" do
        subject.title.should_not == @fork.title
      end
    end
  end

  
  
  it do
    @c1 = Channel.create(:created_by => u1, :title => 'channel 1')
    @c1.add_fact(f1)
    @c2 = @c1.fork(u2)
    @c2.facts.to_a.should =~ [f1]
  end
  
end