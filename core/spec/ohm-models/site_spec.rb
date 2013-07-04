require 'spec_helper'

describe Site do
  subject(:site) { create :site }
  let(:fact1)    { create :fact }
  let(:fact2)    { create :fact }

  describe '#facts' do
    context "initially" do
      it "is empty" do
        expect(site.facts.to_a).to match_array []
      end
    end

    context "after creating one fact with this site " do
      it "contains this fact" do
        fact1.site = site
        fact1.save

        expect(site.facts.to_a).to match_array [fact1]
      end
    end

    context "after creating two facts with this site " do
      it "contains the two facts" do
        fact1.site = site
        fact1.save
        fact2.site = site
        fact2.save

        expect(site.facts.to_a).to match_array [fact1,fact2]
      end
    end
  end

  describe '.find_or_create_by' do
    it 'creates a site if non exists' do
      site = Site.find_or_create_by(url: 'http://example.org')

      expect(site).not_to be_nil
    end
    it 'retrieves a site if the site exists' do
      site = Site.find_or_create_by(url: 'http://example.org')
      site2 = Site.find_or_create_by(url: 'http://example.org')

      expect(site2.id).to eq site.id
    end
  end

  describe ".normalize_url" do
    it "calls UrlNormalizer.normalize" do
      UrlNormalizer.should_receive(:normalize).with('http://hoi')
      Site.normalize_url(url: 'http://hoi')
    end
  end
end
