require 'spec_helper'

def others(opinion)
  others = [:beliefs, :doubts, :disbeliefs]
  others.delete(opinion)
  others
end


def expect_opinion(subject,opinion)
  subject.class[subject.id].get_user_opinion.should == opinion
end

describe Basefact do

  let(:user) {FactoryGirl.create(:user).graph_user}
  let(:user2) {FactoryGirl.create(:user).graph_user}

  subject {FactoryGirl.create(:basefact)}
  let(:fact2) {FactoryGirl.create(:basefact)}

  context "initially" do
    its(:interacting_users) {should be_empty}
    [:beliefs, :doubts, :disbeliefs].each do |opinion|
      it { subject.opiniated_count(opinion).should == 0 }
      it { subject.opiniated(opinion).all.should == [] }
      it { expect_opinion(subject,Opinion.identity)}
    end
  end

  describe "#created_by" do
    context "after setting it" do
      before do
        subject.created_by = user
        subject.save
      end

      it "should have the created_by set" do
        subject.created_by.should == user
      end

      it "should have the created_by persisted" do
        Basefact[subject.id].created_by.should == user
      end

      it "should be findable via find" do
        Basefact.find(:created_by_id => user.id).all.should include(subject)
      end
      it { expect_opinion(subject,Opinion.identity)}
    end
  end

  @opinions = [:beliefs, :doubts, :disbeliefs]
  @opinions.each do |opinion|

    describe "#add_opinion" do
      context "after 1 person has stated its #{opinion}" do
        before do
          subject.add_opinion(opinion, user)
          FactGraph.recalculate
        end
        it { subject.opiniated_count(opinion).should == 1 }
        its(:interacting_users) {should =~ [user]}
        it { expect_opinion(subject,Opinion.for_type(opinion,user.authority))}
      end

      context "after 1 person has stated its #{opinion} twice" do
        before do
          subject.add_opinion(opinion, user)
          subject.add_opinion(opinion, user)
          FactGraph.recalculate
        end
        it {subject.opiniated_count(opinion).should == 1}
        its(:interacting_users) {should =~ [user]}
        it { expect_opinion(subject,Opinion.for_type(opinion,user.authority))}
      end
    end

    describe "#toggle_opinion" do
      context "after one toggle on #{opinion}" do
        before do
          subject.toggle_opinion(opinion,user)
          FactGraph.recalculate
        end
        it { subject.opiniated_count(opinion).should==1 }
        its(:interacting_users) {should =~ [user]}
        it { expect_opinion(subject,Opinion.for_type(opinion,user.authority))}
      end

      context "after two toggles on #{opinion} by the same user" do
        before do
          subject.toggle_opinion(opinion,user)
          subject.toggle_opinion(opinion,user)
          FactGraph.recalculate
        end
        it { subject.opiniated_count(opinion).should == 0 }
        its(:interacting_users) {should be_empty}
        it { expect_opinion(subject,Opinion.identity)}
      end

      context "after two toggles by the different users on the same fact" do
        before do
          subject.toggle_opinion(opinion,user)
          subject.toggle_opinion(opinion,user2)
          FactGraph.recalculate
        end
        it {subject.opiniated_count(opinion).should == 2 }
        its(:interacting_users) {should =~ [user,user2]}
        it { expect_opinion(subject,Opinion.for_type(opinion,user.authority)+Opinion.for_type(opinion,user2.authority))}
      end

      context "after two toggles by the same user on different facts" do
        before do
          subject.toggle_opinion(opinion,user)
          fact2.toggle_opinion(opinion,user)
          FactGraph.recalculate
        end
        it {fact2.opiniated_count(opinion).should == 1}
        it {fact2.interacting_users.should =~ [user]}
        it { expect_opinion(fact2,Opinion.for_type(opinion,user.authority))}

        it {subject.opiniated_count(opinion).should == 1}
        it {subject.interacting_users.should =~ [user]}
        it { expect_opinion(subject,Opinion.for_type(opinion,user.authority))}
      end

      context "after toggling with different opinions" do
        before do 
          subject.toggle_opinion(opinion           ,user)
          subject.toggle_opinion(others(opinion)[0],user)
          FactGraph.recalculate
        end
        it {subject.opiniated_count(opinion).should==0 }
        it {subject.opiniated_count(others(opinion)[0]).should==1 }
        its(:interacting_users) {should == [user]}
        it { expect_opinion(subject,Opinion.for_type(others(opinion)[0],user.authority))}
      end
    end

    context "after one person who #{opinion} is added and deleted" do
      before do
        subject.add_opinion(opinion, user)
        subject.remove_opinions user
        FactGraph.recalculate
      end
      it {subject.opiniated_count(opinion).should == 0 }
      its(:interacting_users) {should == []}
      it { expect_opinion(subject,Opinion.identity)}
    end

    context "after two believers are added" do
      before do
        subject.add_opinion(opinion, user)
        subject.add_opinion(opinion, user2)
        FactGraph.recalculate
      end
      it {subject.opiniated_count(opinion).should == 2}
      its(:interacting_users) {should =~ [user,user2]}
      it { expect_opinion(subject,Opinion.for_type(opinion,user.authority)+Opinion.for_type(opinion,user2.authority))}
    end

    others(opinion).each do |other_opinion|
      context "when two persons start with #{opinion}" do
        before do
          subject.add_opinion(opinion, user)
          subject.add_opinion(opinion, user2)
          FactGraph.recalculate
        end
        context "after person changes its opinion from #{opinion} to #{other_opinion}" do
          before do
            subject.add_opinion(other_opinion, user)
            FactGraph.recalculate
          end
          it {subject.opiniated_count(opinion).should == 1}
          its(:interacting_users) {should =~ [user,user2]}
          it { expect_opinion(subject,Opinion.for_type(other_opinion,user.authority)+Opinion.for_type(opinion,user2.authority))}
        end

        context "after both existing believers change their opinion from #{opinion} to #{other_opinion}" do
          before do
            subject.add_opinion(other_opinion, user)
            subject.add_opinion(other_opinion, user2)
            FactGraph.recalculate
          end
          it {subject.opiniated_count(opinion).should == 0}
          its(:interacting_users) {should =~ [user,user2]}
          it { Basefact[subject.id].get_user_opinion.should == Opinion.for_type(other_opinion,user.authority)+Opinion.for_type(other_opinion,user2.authority)}
        end

      end
    end

  end  


end