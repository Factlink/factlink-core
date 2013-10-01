require 'spec_helper'

describe UrlNormalizer do
  describe ".normalize" do
    def normalized url
      UrlNormalizer.normalize(url)
    end

    describe "normalizing proxy urls" do
      it { normalized( "http://testserver.fct.li/parse?url=http%3A%2F%2Fwww.google.com&factlinkModus=default").should == "http://www.google.com/" }
      it { normalized( "http://staging.fct.li/parse?url=http%3A%2F%2Fwww.google.com&factlinkModus=default").should == "http://www.google.com/" }
      it { normalized( "http://fct.li/parse?url=http%3A%2F%2Fwww.google.com&factlinkModus=default").should == "http://www.google.com/" }
    end
  end
end
