require "spec_helper"

describe FactHelper do
  describe "#friendly_fact_path" do
    it "sluggifies" do
      f = mock(:fact)
      f.should_receive(:to_s).once().and_return("Bla Bla")
      f.should_receive(:id).once().and_return(1)
      helper.friendly_fact_path(f).should eq("/bla-bla/f/1")
    end
  end
end