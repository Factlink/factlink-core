require 'spec_helper'

describe FactGraph do

  describe "exporting should work" do
    it do
      @ch = FactoryGirl.create :channel
      @ch.created_by.user = FactoryGirl.create :user
      @ch.created_by.save

      writer = mock('writer', write: nil)
      FactGraph.export(writer)
    end
  end
end
