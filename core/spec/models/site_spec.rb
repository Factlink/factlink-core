require 'spec_helper'

describe Site do
  subject {FactoryGirl.create(:site)}
  let(:fact1) {FactoryGirl.create(:fact)}
  let(:fact2) {FactoryGirl.create(:fact)}

  context "initially" do
    it "should have an empty facts list" do
      subject.facts.to_a.should =~ []
    end      
  end
  
  context "after creating one fact with this site " do
    before do
      fact1.site = subject
      fact1.save
    end
    it "should contain this fact in the factslist" do
      subject.facts.to_a.should =~ [fact1]
    end
  end

  context "after creating two facts with this site " do
    before do
      fact1.site = subject
      fact1.save
      fact2.site = subject
      fact2.save
    end
    it "should contain this fact in the factslist" do
      subject.facts.to_a.should =~ [fact1,fact2]
    end
  end
  
  it "should have a working find_or_create_by" do
    site = Site.find_or_create_by(:url => 'http://example.org')
    site.should_not == nil
    site2 = Site.find_or_create_by(:url => 'http://example.org')
    site2.id.should == site.id
  end


end