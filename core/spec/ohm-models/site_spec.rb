require 'spec_helper'

describe Site do
  subject(:site) { create :site }
  let(:fact1)    { create :fact }
  let(:fact2)    { create :fact }

  context "initially" do
    it "should have an empty facts list" do
      site.facts.to_a.should =~ []
    end
  end

  context "after creating one fact with this site " do
    before do
      fact1.site = site
      fact1.save
    end
    it "should contain this fact in the factslist" do
      site.facts.to_a.should =~ [fact1]
    end
  end

  context "after creating two facts with this site " do
    before do
      fact1.site = site
      fact1.save
      fact2.site = site
      fact2.save
    end
    it "should contain this fact in the factslist" do
      site.facts.to_a.should =~ [fact1,fact2]
    end
  end

  it "should have a working find_or_create_by" do
    site = Site.find_or_create_by(:url => 'http://example.org')
    site.should_not == nil
    site2 = Site.find_or_create_by(:url => 'http://example.org')
    site2.id.should == site.id
  end

  describe ".normalize_url" do
    it "should call UrlNormalizer.normalize" do
      UrlNormalizer.should_receive(:normalize).with('http://hoi')
      Site.normalize_url(url: 'http://hoi')
    end
  end


end
