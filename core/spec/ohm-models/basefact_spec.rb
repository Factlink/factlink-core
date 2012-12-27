require 'spec_helper'

describe Basefact do

  def self.others(opinion)
    others = [:believes, :doubts, :disbelieves]
    others.delete(opinion)
    others
  end

  # TODO : all tests using this function should be tests
  #        of UserOpinionCalculation
  def expect_opinion(subject,opinion)
    FactGraph.recalculate
    subject.class[subject.id].get_user_opinion.should == opinion
  end

  def user_fact_opinion(user, opinion, fact)
    authority = Authority.on(fact, for: user).to_f + 1
    Opinion.for_type(opinion,authority)
  end

  def self.opinions
    [:believes, :doubts, :disbelieves]
  end


  subject {create(:basefact)}

  let(:fact2) {create(:basefact)}

  let(:user)  {create(:graph_user)}
  let(:user2) {create(:graph_user)}

  context "initially" do
    opinions.each do |opinion|
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


  opinions.each do |opinion|

    describe "#add_opinion" do
      context "after 1 person has stated its #{opinion}" do
        before do
          subject.add_opinion(opinion, user)
        end
        it { expect_opinion(subject,user_fact_opinion(user, opinion, subject))}
      end

      context "after 1 person has stated its #{opinion} twice" do
        before do
          subject.add_opinion(opinion, user)
          subject.add_opinion(opinion, user)
        end
        it { expect_opinion(subject,user_fact_opinion(user, opinion, subject))}
      end
    end


    context "after one person who #{opinion} is added and deleted" do
      before do
        subject.add_opinion(opinion, user)
        subject.remove_opinions user
      end
      it { expect_opinion(subject,Opinion.identity)}
    end

    context "after two believers are added" do
      before do
        subject.add_opinion(opinion, user)
        subject.add_opinion(opinion, user2)
      end
      it { expect_opinion(subject,user_fact_opinion(user, opinion, subject) + user_fact_opinion(user2, opinion, subject))}
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
          it { expect_opinion(subject,user_fact_opinion(user, other_opinion, subject) + user_fact_opinion(user2, opinion, subject))}
       end

        context "after both existing believers change their opinion from #{opinion} to #{other_opinion}" do
          before do
            subject.add_opinion(other_opinion, user)
            subject.add_opinion(other_opinion, user2)
            FactGraph.recalculate
          end
          it { Basefact[subject.id].get_user_opinion.should == (user_fact_opinion(user, other_opinion, subject) + user_fact_opinion(user2, other_opinion, subject)) }
        end

      end
    end
  end

  describe "people believes redis keys" do
    it "should be cleaned up after delete" do
      key = subject.key['people_believes'].to_s
      subject.add_opinion(:believes, user)
      redis = Redis.current
      expect(redis.smembers(key)).to eq [user.id]
      subject.delete
      expect(redis.smembers(key)).to eq []
    end
  end

end
