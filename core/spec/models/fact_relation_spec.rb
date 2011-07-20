require 'spec_helper'

describe FactRelation do

  before(:each) do
    @parent = FactoryGirl.create(:fact)
    @evidence = FactoryGirl.create_list(:fact,2)
    @users = FactoryGirl.create_list(:user,2)

    @fr = @parent.add_evidence(:supporting, @evidence[1], @users[1])
  end


  it "should return a FactRelation when adding evidence" do
    @fr.should be_an_instance_of(FactRelation)
  end

  describe "percentages should work logical" do
    it "should have a percentage of 0 when new" do
      pending
      @fr.percentage.should == 0
    end

  end

  describe "#get_or_create" do
    it "should return a new factrelation when the relation does not exist" do
      @fact1 =FactoryGirl.create(:fact)
      @fact2 =FactoryGirl.create(:fact)
      @fr = FactRelation.get_or_create(@fact1,:supporting,@fact2,@users[0])
      @fr.should be_a(FactRelation)
    end

    it "should find the relation when the relation does exist" do
      @fact1 =FactoryGirl.create(:fact)
      @fact2 =FactoryGirl.create(:fact)
      @fr = FactRelation.get_or_create(@fact1,:supporting,@fact2,@users[0])
      @fr.should be_a(FactRelation)
      @fr2 = FactRelation.get_or_create(@fact1,:supporting,@fact2,@users[0])
      @fr2.should be_a(FactRelation)
    end
  end

end