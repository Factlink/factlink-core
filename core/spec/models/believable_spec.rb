require 'spec_helper'

describe Believable do
  def self.others(opinion)
    others = [:believes, :doubts, :disbelieves]
    others.delete(opinion)
    others
  end

  def user_fact_opinion(user, opinion, fact)
    Opinion.for_type(opinion, 1)
  end

  def self.opinions
    [:believes, :doubts, :disbelieves]
  end

  subject(:believable) { Believable.new Nest.new('gerrit') }

  let(:user)  { create(:graph_user) }
  let(:user2) { create(:graph_user) }

  context "initially" do
    opinions.each do |opinion|
      it { expect(believable.opiniated(opinion).count).to eq 0 }
      it { expect(believable.opiniated(opinion).all).to eq [] }
      it { expect(believable.dead_opinion).to eq DeadOpinion.zero }
    end
  end


  opinions.each do |opinion|

    context "after 1 person has stated its #{opinion}" do
      it do
        believable.add_opiniated(opinion, user)

        expect(believable.opiniated(opinion).count).to eq 1
        expect(believable.dead_opinion).to eq DeadOpinion.for_type(opinion, 1.0)
      end
    end

    context "after 1 person has stated its #{opinion} twice" do
      it do
        believable.add_opiniated(opinion, user)
        believable.add_opiniated(opinion, user)

        expect(believable.opiniated(opinion).count).to eq 1
        expect(believable.dead_opinion).to eq DeadOpinion.for_type(opinion, 1.0)
      end
    end


    context "after one person who #{opinion} is added and deleted" do
      it do
        believable.add_opiniated(opinion, user)
        believable.remove_opinionateds user

        expect(believable.opiniated(opinion).count).to eq 0
        expect(believable.dead_opinion).to eq DeadOpinion.zero
      end
    end

    context "after two believers are added" do
      it do
        believable.add_opiniated(opinion, user)
        believable.add_opiniated(opinion, user2)

        expect(believable.opiniated(opinion).count).to eq 2
        expect(believable.dead_opinion).to eq DeadOpinion.for_type(opinion, 2.0)
      end
    end

    others(opinion).each do |other_opinion|
      context "when two persons start with #{opinion}, after person changes its opinion from #{opinion} to #{other_opinion}" do
        it do
          believable.add_opiniated(opinion, user)
          believable.add_opiniated(opinion, user2)

          believable.add_opiniated(other_opinion, user)

          expect(believable.opiniated(opinion).count).to eq 1
        end
      end

      context "when two persons start with #{opinion}, after both existing believers change their opinion from #{opinion} to #{other_opinion}" do
        it do
          believable.add_opiniated(opinion, user)
          believable.add_opiniated(opinion, user2)

          believable.add_opiniated(other_opinion, user)
          believable.add_opiniated(other_opinion, user2)

          expect(believable.opiniated(opinion).count).to eq 0
          expect(believable.dead_opinion).to eq DeadOpinion.for_type(other_opinion, 2.0)
        end
      end
    end

  end
  describe '.key' do
    it "should be the only value passed to the constructor" do
      key = double
      believable = Believable.new(key)
      expect(believable.key).to eq key
    end
  end
end
