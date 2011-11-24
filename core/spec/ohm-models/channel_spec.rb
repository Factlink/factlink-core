require 'ohm_helper'

require 'active_support/core_ext/module/delegation'
require_relative '../../app/ohm-models/activities.rb'
require_relative '../../app/ohm-models/channel.rb'

class Basefact < OurOhm;end
class Fact < Basefact;end
class GraphUser < OurOhm;end

def create_fact
  FactoryGirl.create :fact
rescue
  Fact.create
end

describe Channel do
  subject {Channel.create(:created_by => u1, :title => "Subject")}

  let(:u1) { GraphUser.create }
  let(:u2) { GraphUser.create }
  let(:u3) { GraphUser.create }
  
  let (:f1) { create_fact }
  let (:f2) { create_fact }
  let (:f3) { create_fact }
  let (:f4) { create_fact }

  
  describe "initially" do
    it { subject.facts.to_a.should =~ []}
    it { subject.containing_channels.to_a.should =~ [] }
  end

  describe "after adding one fact and deleting a fact (not from the Channel but the fact itself) without recalculate" do
    before do
      subject.add_fact(f1)
      f1.delete
      Fact.should_receive(:invalid).with(f1).and_return(true)
    end
    it { subject.facts.to_a.should =~ []}
  end

  
  describe "after adding one fact" do
    before do
      subject.add_fact(f1)
      Fact.should_receive(:invalid).any_number_of_times.and_return(false)
      Channel.recalculate_all
    end
    it do
       subject.facts.to_a.should =~ [f1]
    end

    describe "and removing an fact" do
      before do
        subject.remove_fact(f1)
        Channel.recalculate_all
      end
      it { subject.facts.to_a.should =~ []}
    end
    
    
    
    describe "after forking" do
      before do
        @fork = subject.fork(u2)
        @fork.title = "Fork"
        @fork.save
      end  
      
      it {subject.facts.to_a.should =~ [f1]}
      it {@fork.facts.to_a.should =~ [f1]}

      it {subject.containing_channels.to_a.should =~ [@fork]}
      
      describe "and removing the fact from the original" do
        before do
          subject.remove_fact(f1)
          Channel.recalculate_all
        end
        it {subject.facts.to_a.should =~ []}
        it {subject.sorted_internal_facts.to_a.should =~ []}
        it {subject.sorted_cached_facts.all.to_a.should =~ []}
        it {@fork.sorted_internal_facts.to_a.should =~ []}
        it {@fork.sorted_cached_facts.to_a.should =~ []}
        it {@fork.facts.to_a.should =~ []}
      end
      describe "and removing the fact from the fork" do
        before do
           @fork.remove_fact(f1)
        end
        it {subject.facts.to_a.should =~ [f1]}
        it {@fork.facts.to_a.should =~ []}
      end
      describe "after adding another fact to the original" do
        before do
           subject.add_fact(f2)
           Channel.recalculate_all
        end
        it {subject.facts.to_a.should == [f2,f1]}
        it {@fork.facts.to_a.should == [f2,f1]}
      end
      describe "after adding another fact to the fork" do
        before do
           @fork.add_fact(f2)
        end
        it {subject.facts.to_a.should == [f1]}
        it {@fork.facts.to_a.should == [f2,f1]}
      end
    end
  end
end