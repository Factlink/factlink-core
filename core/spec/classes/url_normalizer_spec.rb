require File.expand_path('../../../app/classes/url_normalizer.rb', __FILE__)

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
  end
end
