require 'spec_helper'

describe FactRelation do
  subject { create(:fact_relation) }

  let(:gu) { create(:full_user).graph_user }
  let(:gu2) { create(:full_user).graph_user }

  let(:evidence) { create :fact }
  let(:parent) { create :fact }

  let(:fact1) { create :fact }
  let(:fact2) { create :fact }

  describe "#get_or_create" do
    it "should return a new factrelation when the relation does not exist" do
      fr = FactRelation.get_or_create(fact1, :believes, fact2, gu)
      fr.should be_a(FactRelation)
      fr.should_not be_new
    end

    it "doesn't return a new factrelation when the relation type does exist" do
      fr = FactRelation.new type: :believes,
                            fact: fact1,
                            from_fact: fact2,
                            created_by: gu
      fr.save
      fr.should_not be_new
    end

    it "should return a new factrelation when the relation type does not exist" do
      fr = FactRelation.new type: :retroverting,
                            fact: fact1,
                            from_fact: fact2,
                            created_by: gu
      fr.save
      fr.should be_new
    end

    it "should have a created_by GraphUser when created" do
      fr = FactRelation.get_or_create(evidence, :believes, parent, gu)
      fr.created_by.should be_a(GraphUser)
    end

    it "should find the relation when the relation does exist" do
      fr = FactRelation.get_or_create(fact1,:believes,fact2,gu)
      fr.should be_a(FactRelation)
      fr2 = FactRelation.get_or_create(fact1,:believes,fact2,gu)
      fr2.should be_a(FactRelation)
      fr3 = FactRelation.get_or_create(fact1,:believes,fact2,gu)
      fr3.should be_a(FactRelation)
      expect(fr).to eq fr2
      expect(fr2).to eq fr3
    end
  end

  it "should not be able to create identical factRelations" do
    FactRelation.get_or_create(fact1,:believes,fact2,gu)
    FactRelation.get_or_create(fact1,:believes,fact2,gu)
    expect(FactRelation.all.size).to eq 1
    FactRelation.get_or_create(fact2,:believes,fact1,gu)
    FactRelation.get_or_create(fact2,:believes,fact1,gu)
    expect(FactRelation.all.size).to eq 2
  end

  describe :deletable? do
    include PavlovSupport
    let(:fr) { FactRelation.get_or_create(fact1,:believes,fact2,gu) }

    it "should be true initially" do
      fr.deletable?.should be_true
    end
    it "should be true if only the creator believes it" do
      fr.add_opiniated(:believes, gu)
      fr.deletable?.should be_true
    end
    it "should be false after someone else believes the relation" do
      fr.add_opiniated(:believes, gu2)
      fr.deletable?.should be_false
    end
    it "should be true if only the creator believes it" do
      fr.add_opiniated(:disbelieves, gu2)
      fr.deletable?.should be_true
    end
    it "should be true if only the creator believes it" do
      fr.add_opiniated(:doubts, gu2)
      fr.deletable?.should be_true
    end
  end

  describe "people believes redis keys" do
    it "should be cleaned up after delete" do
      user = create(:graph_user)
      key = subject.key['people_believes'].to_s
      subject.add_opinion(:believes, user)
      redis = Redis.current
      expect(redis.smembers(key)).to eq [user.id]

      subject.delete

      expect(redis.smembers(key)).to eq []
    end
  end
end
