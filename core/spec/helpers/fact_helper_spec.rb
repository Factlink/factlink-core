require "spec_helper"

describe FactHelper do
  describe "#friendly_fact_path" do
    it "sluggifies" do
      f = mock(:fact)
      f.should_receive(:to_s).any_number_of_times().and_return("Bla Bla")
      f.should_receive(:id).any_number_of_times().and_return(1)
      helper.friendly_fact_path(f).should eq("/bla-bla/f/1")
    end

    it "falls back on empty displaystring" do
      f = mock(:fact)
      f.should_receive(:to_s).any_number_of_times().and_return("")
      f.should_receive(:id).any_number_of_times().and_return(1)
      helper.friendly_fact_path(f).should eq("/1/f/1")
    end

    it "should have a maximum length" do
      max_slug_length = 5

      f = mock(:fact)
      f.should_receive(:to_s).any_number_of_times().and_return("Bla Bla Bla Bla")
      f.should_receive(:id).any_number_of_times().and_return(1)
      helper.friendly_fact_path(f, max_slug_length).should eq("/bla-b/f/1")
    end
  end
end