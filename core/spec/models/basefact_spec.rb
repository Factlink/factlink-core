require 'spec_helper'

def others(opinion)
  others = [:beliefs, :doubts, :disbeliefs]
  others.delete(opinion)
  others
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
    end
  end

  @opinions = [:beliefs, :doubts, :disbeliefs]
  @opinions.each do |opinion|

    describe "#add_opinion" do
      context "after 1 person has stated its #{opinion}" do
        before do
          subject.add_opinion(opinion, user)
        end
        it { subject.opiniated_count(opinion).should == 1 }
        its(:interacting_users) {should =~ [user]}
        its(:get_opinion) {should == Opinion.for_type(opinion,user.authority)}
      end


      context "after 1 person has stated its #{opinion}" do
        before do
          subject.add_opinion(opinion, user)
        end
        it { subject.opiniated_count(opinion).should == 1 }
        its(:interacting_users) {should =~ [user]}
      end

      context "after 1 person has stated its #{opinion} twice" do
        before do
          subject.add_opinion(opinion, user)
          subject.add_opinion(opinion, user)
        end
        it {subject.opiniated_count(opinion).should == 1}
        its(:interacting_users) {should =~ [user]}
      end
    end

    describe "#toggle_opinion" do
      context "after one toggle on #{opinion}" do
        before do
          subject.toggle_opinion(opinion,user)
        end
        it { subject.opiniated_count(opinion).should==1 }
        its(:interacting_users) {should =~ [user]}
      end

      context "after two toggles on #{opinion} by the same user" do
        before do
          subject.toggle_opinion(opinion,user)
          subject.toggle_opinion(opinion,user)
        end
        it { subject.opiniated_count(opinion).should == 0 }
        its(:interacting_users) {should be_empty}
      end

      context "after two toggles by the different users on the same fact" do
        before do
          subject.toggle_opinion(opinion,user)
          subject.toggle_opinion(opinion,user2)
        end
        it {subject.opiniated_count(opinion).should == 2 }
        its(:interacting_users) {should =~ [user,user2]}
      end

      context "after two toggles by the same user on different facts" do
        before do
          subject.toggle_opinion(opinion,user)
          fact2.toggle_opinion(opinion,user)
        end
        it {fact2.opiniated_count(opinion).should == 1}
        it {fact2.interacting_users.should =~ [user]}

        it {subject.opiniated_count(opinion).should == 1}
        it {subject.interacting_users.should =~ [user]}
      end

      context "after toggling with different opinions" do
        before do 
          subject.toggle_opinion(opinion           ,user)
          subject.toggle_opinion(others(opinion)[0],user)
        end
        it {subject.opiniated_count(opinion).should==0 }
        it {subject.opiniated_count(others(opinion)[0]).should==1 }
        its(:interacting_users) {should == [user]}
      end
    end

    context "after one person who #{opinion} is added and deleted" do
      before do
        subject.add_opinion(opinion, user)
        subject.remove_opinions user
      end
      it {subject.opiniated_count(opinion).should == 0 }
      its(:interacting_users) {should == []}
    end

    context "after two believers are added" do
      before do
        subject.add_opinion(opinion, user)
        subject.add_opinion(opinion, user2)
      end
      it {subject.opiniated_count(opinion).should == 2}
      its(:interacting_users) {should =~ [user,user2]}
    end

    others(opinion).each do |other_opinion|
      context "when two persons start with #{opinion}" do
        before do
          subject.add_opinion(opinion, user)
          subject.add_opinion(opinion, user2)
        end
        context "after person changes its opinion from #{opinion} to #{other_opinion}" do
          before do
            subject.add_opinion(other_opinion, user)
          end
          it {subject.opiniated_count(opinion).should == 1}
          its(:interacting_users) {should =~ [user,user2]}
        end

        context "after both existing believers change their opinion from #{opinion} to #{other_opinion}" do
          before do
            subject.add_opinion(other_opinion, user)
            subject.add_opinion(other_opinion, user2)
          end
          it {subject.opiniated_count(opinion).should == 0}
          its(:interacting_users) {should =~ [user,user2]}
        end

        context "after an existing believer changes its opinion to #{other_opinion}" do
          before do
            subject.add_opinion(other_opinion, user)
          end
          it { subject.opiniated_count(opinion).should == 1 }
          its(:interacting_users) {should =~ [user,user2]}
        end
      end
    end

  end  

  describe "opinions should give certain values" do
    it "should initially be zero" do
      @basefact = Basefact.new
      @basefact.get_opinion.should == Opinion.neew(0,0,0,0)
    end
  end

end