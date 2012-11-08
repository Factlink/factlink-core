require File.expand_path('../../../../../app/classes/url_normalizer.rb', __FILE__)
require 'uri'
require 'base64'

describe UrlNormalizer do
  describe ".normalize" do
    def normalized url
      UrlNormalizer.normalize(url)
    end

    def base
      'http://www.nytimes.com/2011/10/30/opinion/mona-simpsons-eulogy-for-steve-jobs.html'
    end

    it { normalized(base + '?_r=1').should == base }
    it { normalized(base + '?_r=1&utm_source=frank').should == base }

    it { normalized(base + '?pagewanted=all&_r=0').should ==
                    base + '?pagewanted=all' }

    it { normalized(base + '?pagewanted=2&_r=1utm_source=buffer&buffer_share=b0b26').should ==
                    base + '?pagewanted=2' }

  end
end
