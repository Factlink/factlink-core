require File.expand_path('../../../app/classes/url_normalizer.rb', __FILE__)

describe UrlNormalizer do
  describe ".normalize" do
    def should_normalize_to(url, expected)
      UrlNormalizer.normalize(url).should == expected
    end
    
    it { should_normalize_to 'http://www.google.com/foo', 'http://www.google.com/foo'}
  end
  
end