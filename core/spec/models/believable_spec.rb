require 'spec_helper'

describe Believable do
  subject(:believable) { Believable.new Nest.new('gerrit') }

  let(:user)  { create(:graph_user) }
  let(:user2) { create(:graph_user) }

  context "initially" do
    [:believes, :doubts, :disbelieves].each do |opinion|
      it { expect(believable.opiniated(opinion).count).to eq 0 }
      it { expect(believable.opiniated(opinion).all).to eq [] }
    end

    it { expect(believable.votes).to eq(believes: 0, disbelieves: 0, doubts: 0) }
  end

  context "after 1 person has stated its believes" do
    it do
      believable.add_opiniated(:believes, user)

      expect(believable.opiniated(:believes).count).to eq 1
      expect(believable.votes).to eq(believes: 1, disbelieves: 0, doubts: 0)
    end
  end

  context "after 1 person has stated its believes twice" do
    it do
      believable.add_opiniated(:believes, user)
      believable.add_opiniated(:believes, user)

      expect(believable.opiniated(:believes).count).to eq 1
      expect(believable.votes).to eq(believes: 1, disbelieves: 0, doubts: 0)
    end
  end


  context "after one person who believes is added and deleted" do
    it do
      believable.add_opiniated(:believes, user)
      believable.remove_opinionateds user

      expect(believable.opiniated(:believes).count).to eq 0
      expect(believable.votes).to eq(believes: 0, disbelieves: 0, doubts: 0)
    end
  end

  context "after two believers are added" do
    it do
      believable.add_opiniated(:believes, user)
      believable.add_opiniated(:believes, user2)

      expect(believable.opiniated(:believes).count).to eq 2
      expect(believable.votes).to eq(believes: 2, disbelieves: 0, doubts: 0)
    end
  end

  context "when two persons start with believes, after person changes its opinion from believes to disbelieves" do
    it do
      believable.add_opiniated(:believes, user)
      believable.add_opiniated(:believes, user2)

      believable.add_opiniated(:disbelieves, user)

      expect(believable.opiniated(:believes).count).to eq 1
      expect(believable.votes).to eq(believes: 1, disbelieves: 1, doubts: 0)
    end
  end

  context "when two persons start with believes, after both existing believers change their opinion from believes to doubts" do
    it do
      believable.add_opiniated(:believes, user)
      believable.add_opiniated(:believes, user2)

      believable.add_opiniated(:doubts, user)
      believable.add_opiniated(:doubts, user2)

      expect(believable.opiniated(:believes).count).to eq 0
      expect(believable.votes).to eq(believes: 0, disbelieves: 0, doubts: 2)
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
