require 'spec_helper'


describe "calculating an opinion based on a set of believers, disbelievers and doubters" do
  subject {create(:basefact)}

  let(:fact2) {create(:basefact)}

  let(:user)  {create(:graph_user)}
  let(:user2) {create(:graph_user)}

  def self.opinions
    [:believes, :doubts, :disbelieves]
  end

  def self.others(opinion)
    others = [:believes, :doubts, :disbelieves]
    others.delete(opinion)
    others
  end

  def opinion_on(subject)
    calculation = UserOpinionCalculation.new(subject) do
      Authority.on(fact, for: user).to_f + 1
    end
    calculation.opinion
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

  describe 'a basefact with no creator' do
    it 'has no opinion' do
      expect(opinion_on(subject)).to eq Opinion.zero
    end
  end

  opinions.each do |opinion|
    context "after 1 person has stated its #{opinion}" do
      it do
        subject.add_opinion(opinion, user)
        expect_opinion(subject,user_fact_opinion(user, opinion, subject))
      end
    end

    context "after two believers are added" do
      before do
        subject.add_opinion(opinion, user)
        subject.add_opinion(opinion, user2)
        expect_opinion(subject,user_fact_opinion(user, opinion, subject) + user_fact_opinion(user2, opinion, subject))
      end
    end
  end
end
