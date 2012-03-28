require File.expand_path('../../../app/classes/url_normalizer.rb', __FILE__)

describe UrlNormalizer do
  describe ".normalize" do
    def should_normalize_to(url, expected)
      UrlNormalizer.normalize(url).should == expected
    end

    it { should_normalize_to 'http://www.google.com/foo', 'http://www.google.com/foo' }
    it { should_normalize_to 'http://www.google.com/foo#bar', 'http://www.google.com/foo' }

    pending "fixing issue #140" do
      ['utm_source', 'utm_medium', 'utm_source', 'utm_content', 'utm_campaign'].each do |strip_param|
        it { should_normalize_to "http://www.google.com/foo?#{strip_param}=bar",'http://www.google.com/foo'}
        it { should_normalize_to "http://www.google.com/foo?#{strip_param}=bar&x=y",'http://www.google.com/foo?x=y'}
      end
    end

  end

end