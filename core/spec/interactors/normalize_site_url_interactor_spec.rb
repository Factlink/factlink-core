require 'spec_helper'

describe NormalizeSiteUrlInteractor do

  def fake_class
    Class.new
  end

  before do
    @s1 = create :site, url: 'http://foo.com/?boring=gaap'
    @s2 = create :site, url: 'http://foo.com/?boring=yawn'

    @f1 = create :fact, site: @s1
    @f2 = create :fact, site: @s2

    @f3 = create :fact, site: @s1
    @f4 = create :fact, site: @s2

    stub_const('DumbUrlNormalizer', fake_class)
    DumbUrlNormalizer.stub(normalize: 'http://foo.com')

  end

  it "should migrate one site when there is no site yet with the new url" do
    interactor = NormalizeSiteUrlInteractor.perform(@s1.id, :DumbUrlNormalizer)
    Fact[@f1.id].site.url.should == 'http://foo.com'
  end

  it "should be able to merge multiple sites which end up with the same url after normalization" do
    interactor = NormalizeSiteUrlInteractor.perform(@s1.id, :DumbUrlNormalizer)
    Fact[@f1.id].site.url.should == 'http://foo.com'
    Fact[@f3.id].site.url.should == 'http://foo.com'

    interactor = NormalizeSiteUrlInteractor.perform(@s2.id, :DumbUrlNormalizer)
    Fact[@f2.id].site.url.should == 'http://foo.com'
    Fact[@f4.id].site.url.should == 'http://foo.com'

    Site.all.count.should == 1
  end
end