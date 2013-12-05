require 'spec_helper'

describe FactHelper do
  describe :fast_remove_fact_from_channel_path do
    it "gives the same result as remove_fact_from_channel_path" do
      args = ['username',10,13]
      helper.fast_remove_fact_from_channel_path(*args).should == helper.remove_fact_from_channel_path(*args)
    end
  end
end
