require 'spec_helper'

# NOTE: since this test doesn't test authority calculation
#       we take it to be 1 everywhere

describe "calculating an opinion based on a set of believers, disbelievers and doubters" do
  subject {create(:basefact)}

  let(:user)  {create(:graph_user)}
  let(:user2) {create(:graph_user)}

  describe 'a basefact with no creator' do
    it 'has no opinion' do
      calculation = UserOpinionCalculation.new(subject) { 1 }
      actual_opinion = calculation.opinion

      expect(actual_opinion).to eq DeadOpinion.zero
    end
  end

  [:believes, :doubts, :disbelieves].each do |opinion|
    context "after 1 person has stated she #{opinion}" do
      it 'has the opinion #{opinion} with authority of the user' do
        subject.add_opinion(opinion, user)

        calculation = UserOpinionCalculation.new(subject) { 1 }
        actual_opinion = calculation.opinion

        expected_opinion = DeadOpinion.for_type(opinion, 1)
        expect(actual_opinion).to eq expected_opinion
      end
    end
  end

  context "after two users express belief" do
    it 'returns a beliefing opinion with the authority of both users combined' do
      subject.add_opinion(:believes, user)
      subject.add_opinion(:believes, user2)

      calculation = UserOpinionCalculation.new(subject) { 1 }
      actual_opinion = calculation.opinion

      expected_opinion = DeadOpinion.for_type(:believes, 1) +
                         DeadOpinion.for_type(:believes, 1)
      expect(actual_opinion).to eq expected_opinion
    end
  end

  context "after one user expresses belief, and the other disbelief" do
    it 'returns a opinion which combines the two' do
      subject.add_opinion(:believes, user)
      subject.add_opinion(:disbelieves, user2)

      calculation = UserOpinionCalculation.new(subject) { 1 }
      actual_opinion = calculation.opinion

      expected_opinion = DeadOpinion.for_type(:believes, 1) +
                         DeadOpinion.for_type(:disbelieves, 1)
      expect(actual_opinion).to eq expected_opinion
    end
  end
end
