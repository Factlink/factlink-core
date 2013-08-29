require 'pavlov_helper'
require_relative '../../../app/interactors/interactors/normalize_site_url.rb'

describe Interactors::NormalizeSiteUrl do

  before do
    stub_const('Site', Class.new)
    stub_const('DumbUrlNormalizer', Class.new)
    DumbUrlNormalizer.stub(normalize: 'http://foo.com')
  end

  it 'should migrate one site when there is no site yet with the new url' do
    site = double id: 1, url: 'http://foo.com/?boring=gaap'
    Site.should_receive(:[]).with(site.id).and_return(site)
    site.should_receive(:url=).with('http://foo.com')
    site.should_receive(:save).and_return true

    interactor = Interactors::NormalizeSiteUrl.perform(site_id: site.id,
      normalizer_class_name: :DumbUrlNormalizer)
  end

  it 'should be able to merge multiple sites which end up with the same url after normalization' do
    site1 = double id: 1, url: 'http://foo.com/?boring=gaap'
    fact1 = double id: 3, site: site1
    fact2 = double id: 4, site: site1
    site1.stub(facts: [fact1, fact2])
    site2 = double id: 2, url: 'http://foo.com'

    Site.should_receive(:[]).with(site1.id).and_return(site1)
    site1.should_receive(:url=).with('http://foo.com')
    site1.should_receive(:save).and_return false
    Site.should_receive(:find_or_create_by).and_return(site2)

    [fact1, fact2].each do |fact|
      fact.should_receive(:site=).with(site2)
      fact.should_receive(:save)
    end

    # The facts aren't removed from site1 since this isn't a real model
    # so the site shouldn't be removed
    site1.should_not_receive(:delete)

    interactor = Interactors::NormalizeSiteUrl.perform(site_id: site1.id,
      normalizer_class_name: :DumbUrlNormalizer)
  end
end
