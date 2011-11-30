require 'spec_helper'

describe FactGraph do

  describe "exporting should work" do
    it do
      @ch = FactoryGirl.create :channel
      
      writer = mock('writer', write: nil)
      FactGraph.export(writer)
    end
  end
end
