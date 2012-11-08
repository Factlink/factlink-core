require File.expand_path('../../../app/classes/url_normalizer.rb', __FILE__)
require 'uri'
require 'base64'

describe UrlNormalizer do
  describe ".normalize" do
    def normalized url
      UrlNormalizer.normalize(url)
    end

    it { normalized('http://www.google.com/foo').should == 'http://www.google.com/foo' }
    it { normalized('http://www.google.com/foo#bar').should == 'http://www.google.com/foo' }

    ['utm_source', 'utm_medium', 'utm_source', 'utm_content', 'utm_campaign'].each do |strip_param|
      it "should strip #{strip_param} if it is the only parameter" do
        normalized("http://www.google.com/foo?#{strip_param}=bar").should == 'http://www.google.com/foo'
      end
      it "should strip #{strip_param} if there are other parameters" do
        normalized("http://www.google.com/foo?#{strip_param}=bar&x=y").should == 'http://www.google.com/foo?x=y'
      end
    end

    it { normalized( 'http://www.google.com/?x=y|z').should == 'http://www.google.com/?x=y%7Cz' }
    it { normalized( 'http://www.google.com/?x=y|z').should == 'http://www.google.com/?x=y%7Cz' }

    it { normalized( 'http://www.example.org/file\bier.png').should == 'http://www.example.org/file%5Cbier.png' }

    it { normalized( 'http://www.ikea.com/nl/nl/catalog/products/30101154/?icid=nl|ic|hp_main|smarteasyliving|ikea365').should ==
                             'http://www.ikea.com/nl/nl/catalog/products/30101154/?icid=nl%7Cic%7Chp_main%7Csmarteasyliving%7Cikea365'}

    it { normalized( 'http://www.amazon.de/s/url=search-alias%3Daps').should ==
                            'http://www.amazon.de/s/url=search-alias=aps'}
    it { normalized( 'http://www.amazon.de/s/?url=search-alias%3Daps').should ==
                             'http://www.amazon.de/s/?url=search-alias=aps'}
    describe "improvements" do

      it { normalized( 'http://www.google.com/a[b]').should == 'http://www.google.com/a%5Bb%5D' } # [ and ] are not allowed according to RFC 2732 http://www.ietf.org/rfc/rfc2732.txt
      it { normalized( 'http://www.google.com/foo?bar=bax|zuup').should == 'http://www.google.com/foo?bar=bax%7Czuup' }

      describe "normalizing proxy urls" do

        it { normalized( "http://testserver.fct.li/parse?url=http%3A%2F%2Fwww.google.com&factlinkModus=default").should == "http://www.google.com/" }
        it { normalized( "http://staging.fct.li/parse?url=http%3A%2F%2Fwww.google.com&factlinkModus=default").should == "http://www.google.com/" }
        it { normalized( "http://fct.li/parse?url=http%3A%2F%2Fwww.google.com&factlinkModus=default").should == "http://www.google.com/" }

      end
      describe "it should work on normal proxy urls" do
        it { normalized( "http://fct.li/").should == "http://fct.li/" }
      end
    end
    it {normalized( 'http://www.example.com/ff/entry.asp?123').should == 'http://www.example.com/ff/entry.asp?123'}


    it {normalized( 'http://example.com/foo?x=^y').should == 'http://example.com/foo?x=%5Ey'}
    it {normalized( 'http://example.com/foo?x=%y').should == 'http://example.com/foo?x=%25y'}
    it {normalized( 'http://example.com/foo?x={y}').should == 'http://example.com/foo?x=%7By%7D'}
    it {normalized( 'http://example.org/search.php?a=%F6').should == 'http://example.org/search.php?a=%F6'}
    def decode_utf8_b64(string)
      URI.unescape(string)
    end
    it "should not bug with invalid encodings" do
      normalized( decode_utf8_b64("http%3A%2F%2Fwww.mercuryserver.com%2Fforums%2Fshowthread.php%3F100800-Stephan-Bodzin-amp-Marc-Romboy-%2596-Live-Luna-Live-Tour-(Harry-Klein-M%25FCnchen)-%2596-23-04-2")).should ==
               "http://www.mercuryserver.com/forums/showthread.php?100800-Stephan-Bodzin-amp-Marc-Romboy-%96-Live-Luna-Live-Tour-(Harry-Klein-M%FCnchen)-%96-23-04-2"
    end
  end
end
