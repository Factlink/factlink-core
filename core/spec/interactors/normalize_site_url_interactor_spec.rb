require File.expand_path('../../../app/interactors/normalize_site_url_interactor.rb', __FILE__)

describe NormalizeSiteUrlInteractor do

  before do
    stub_const('Site', Class.new)
    stub_const('DumbUrlNormalizer', Class.new)
    DumbUrlNormalizer.stub(normalize: 'http://foo.com')
  end

  it "should migrate one site when there is no site yet with the new url" do
    site = mock id: 1, url: 'http://foo.com/?boring=gaap'
    Site.should_receive(:[]).with(site.id).and_return(site)
    site.should_receive(:url=).with('http://foo.com')
    site.should_receive(:save).and_return true

    interactor = NormalizeSiteUrlInteractor.perform(site.id, :DumbUrlNormalizer)
  end

  it "should be able to merge multiple sites which end up with the same url after normalization" do
    site1 = mock id: 1, url: 'http://foo.com/?boring=gaap'
    fact1 = mock id: 3, site: site1
    fact2 = mock id: 4, site: site1
    site1.stub(facts: [fact1, fact2])
    site2 = mock id: 2, url: 'http://foo.com'

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

    interactor = NormalizeSiteUrlInteractor.perform(site1.id, :DumbUrlNormalizer)
  end
end
