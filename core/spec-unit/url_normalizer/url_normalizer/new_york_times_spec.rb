require_relative '../../../app/classes/url_normalizer.rb'
require 'uri'
require 'base64'

describe UrlNormalizer do
  describe ".normalize" do
    def normalized url
      UrlNormalizer.normalize(url)
    end

    let(:base){'http://www.nytimes.com/2011/10/30/opinion/mona-simpsons-eulogy-for-steve-jobs.html'}

    it { normalized(base + '?_r=1').should == base }
    it { normalized(base + '?_r=1&utm_source=frank').should == base }

    it do
     normalized(base + '?pagewanted=all&_r=0').should ==
                    base + '?pagewanted=all'
    end

    it do
     normalized(base + '?pagewanted=2&_r=1utm_source=buffer&buffer_share=b0b26').should ==
                    base + '?pagewanted=2'
    end

  end
end
