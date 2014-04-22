require 'spec_helper'

describe Believable do
  subject(:believable) { Believable.new Nest.new('gerrit') }

  let(:user)  { create(:user) }
  let(:user2) { create(:user) }

  context "initially" do
    it { expect(believable.votes).to eq(believes: 0, disbelieves: 0) }
  end

  context "after 1 person has stated its believes" do
    it do
      believable.add_opiniated_id(:believes, user.id)

      expect(believable.votes).to eq(believes: 1, disbelieves: 0)
    end
  end

  context "after 1 person has stated its believes twice" do
    it do
      believable.add_opiniated_id(:believes, user.id)
      believable.add_opiniated_id(:believes, user.id)

      expect(believable.votes).to eq(believes: 1, disbelieves: 0)
    end
  end


  context "after one person who believes is added and deleted" do
    it do
      believable.add_opiniated_id(:believes, user.id)
      believable.remove_opinionated_id user.id

      expect(believable.votes).to eq(believes: 0, disbelieves: 0)
    end
  end

  context "after two believers are added" do
    it do
      believable.add_opiniated_id(:believes, user.id)
      believable.add_opiniated_id(:believes, user2.id)

      expect(believable.votes).to eq(believes: 2, disbelieves: 0)
    end
  end

  context "when two persons start with believes, after person changes its opinion from believes to disbelieves" do
    it do
      believable.add_opiniated_id(:believes, user.id)
      believable.add_opiniated_id(:believes, user2.id)

      believable.add_opiniated_id(:disbelieves, user.id)

      expect(believable.votes).to eq(believes: 1, disbelieves: 1)
    end
  end

  context "when two persons start with believes, after both existing believers change their opinion from believes to disbelieves" do
    it do
      believable.add_opiniated_id(:believes, user.id)
      believable.add_opiniated_id(:believes, user2.id)

      believable.add_opiniated_id(:disbelieves, user.id)
      believable.add_opiniated_id(:disbelieves, user2.id)

      expect(believable.votes).to eq(believes: 0, disbelieves: 2)
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
