require File.expand_path('../../../app/classes/url_normalizer.rb', __FILE__)
require 'uri'
require 'base64'

describe UrlNormalizer do
  describe ".normalize" do
    def should_normalize_to(url, expected)
      UrlNormalizer.normalize(url).should == expected
    end

    it { should_normalize_to 'http://www.google.com/foo', 'http://www.google.com/foo' }
    it { should_normalize_to 'http://www.google.com/foo#bar', 'http://www.google.com/foo' }

    ['utm_source', 'utm_medium', 'utm_source', 'utm_content', 'utm_campaign'].each do |strip_param|
      it "should strip #{strip_param} if it is the only parameter" do
        should_normalize_to "http://www.google.com/foo?#{strip_param}=bar",'http://www.google.com/foo'
      end
      it "should strip #{strip_param} if there are other parameters" do
        should_normalize_to "http://www.google.com/foo?#{strip_param}=bar&x=y",'http://www.google.com/foo?x=y'
      end
    end

    it { should_normalize_to 'http://www.google.com/?x=y|z', 'http://www.google.com/?x=y%7Cz' }
    it { should_normalize_to 'http://www.google.com/?x=y|z', 'http://www.google.com/?x=y%7Cz' }

    it { should_normalize_to 'http://www.example.org/file\bier.png', 'http://www.example.org/file%5Cbier.png' }

    it { should_normalize_to 'http://www.ikea.com/nl/nl/catalog/products/30101154/?icid=nl|ic|hp_main|smarteasyliving|ikea365',
                             'http://www.ikea.com/nl/nl/catalog/products/30101154/?icid=nl%7Cic%7Chp_main%7Csmarteasyliving%7Cikea365'}

    it { should_normalize_to 'http://www.amazon.de/s/url=search-alias%3Daps',
                            'http://www.amazon.de/s/url=search-alias=aps'}
    it { should_normalize_to 'http://www.amazon.de/s/?url=search-alias%3Daps',
                             'http://www.amazon.de/s/?url=search-alias=aps'}
    describe "improvements" do

      it { should_normalize_to 'http://www.google.com/a[b]', 'http://www.google.com/a%5Bb%5D' } # [ and ] are not allowed according to RFC 2732 http://www.ietf.org/rfc/rfc2732.txt
      it { should_normalize_to 'http://www.google.com/foo?bar=bax|zuup', 'http://www.google.com/foo?bar=bax%7Czuup' }

      describe "normalizing proxy urls" do

        it { should_normalize_to "http://testserver.fct.li/parse?url=http%3A%2F%2Fwww.google.com&factlinkModus=default", "http://www.google.com/" }
        it { should_normalize_to "http://staging.fct.li/parse?url=http%3A%2F%2Fwww.google.com&factlinkModus=default", "http://www.google.com/" }
        it { should_normalize_to "http://fct.li/parse?url=http%3A%2F%2Fwww.google.com&factlinkModus=default", "http://www.google.com/" }

      end
      describe "it should work on normal proxy urls" do
        it { should_normalize_to "http://fct.li/", "http://fct.li/" }
      end
    end
    it {should_normalize_to 'http://www.example.com/ff/entry.asp?123', 'http://www.example.com/ff/entry.asp?123'}


    it {should_normalize_to 'http://example.com/foo?x=^y', 'http://example.com/foo?x=%5Ey'}
    it {should_normalize_to 'http://example.com/foo?x=%y', 'http://example.com/foo?x=%25y'}
    it {should_normalize_to 'http://example.com/foo?x={y}', 'http://example.com/foo?x=%7By%7D'}
    it {should_normalize_to 'http://example.org/search.php?a=%F6', 'http://example.org/search.php?a=%F6'}
    def decode_utf8_b64(string)
      URI.unescape(string)
    end
    it "should not bug with invalid encodings" do
      should_normalize_to decode_utf8_b64("http%3A%2F%2Fwww.mercuryserver.com%2Fforums%2Fshowthread.php%3F100800-Stephan-Bodzin-amp-Marc-Romboy-%2596-Live-Luna-Live-Tour-(Harry-Klein-M%25FCnchen)-%2596-23-04-2"),
               "http://www.mercuryserver.com/forums/showthread.php?100800-Stephan-Bodzin-amp-Marc-Romboy-%96-Live-Luna-Live-Tour-(Harry-Klein-M%FCnchen)-%96-23-04-2"
    end
  end
end
