require 'spec_helper'


describe "calculating an opinion based on a set of believers, disbelievers and doubters" do
  subject {create(:basefact)}

  let(:fact2) {create(:basefact)}

  let(:user)  {create(:graph_user)}
  let(:user2) {create(:graph_user)}

  def self.opinions
    [:believes, :doubts, :disbelieves]
  end

  def opinion_on(subject)
    calculation = UserOpinionCalculation.new(subject) { 1 }
    calculation.opinion
  end

  def user_fact_opinion(user, opinion, fact)
    Opinion.for_type(opinion,1)
  end

  describe 'a basefact with no creator' do
    it 'has no opinion' do
      actual_opinion = opinion_on(subject)
      expect(actual_opinion).to eq Opinion.zero
    end
  end

  opinions.each do |opinion|
    context "after 1 person has stated she #{opinion}" do
      it 'has the opinion #{opinion} with authority of the user' do
        subject.add_opinion(opinion, user)
        actual_opinion = opinion_on(subject)
        expected_opinion = user_fact_opinion(user, opinion, subject)
        expect(actual_opinion).to eq expected_opinion
      end
    end
  end

  context "after two users express belief" do
    it 'returns a beliefing opinion with the authority of both users combined' do
      subject.add_opinion(:believes, user)
      subject.add_opinion(:believes, user2)
      actual_opinion = opinion_on(subject)
      expected_opinion = user_fact_opinion(user, :believes, subject) +
                         user_fact_opinion(user2, :believes, subject)
      expect(actual_opinion).to eq expected_opinion
    end
  end

  context "after one user expresses belief, and the other disbelief" do
    it 'returns a opinion which combines the two' do
      subject.add_opinion(:believes, user)
      subject.add_opinion(:disbelieves, user2)
      actual_opinion = opinion_on(subject)
      expected_opinion = user_fact_opinion(user, :believes, subject) +
                         user_fact_opinion(user2, :disbelieves, subject)
      expect(actual_opinion).to eq expected_opinion
    end
  end
end
