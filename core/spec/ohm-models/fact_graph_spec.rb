require 'spec_helper'
require_relative '../../db/load_dsl.rb'

describe FactGraph do

  describe "exporting should work" do
    it do
      @ch = FactoryGirl.create :channel
      
      writer = mock('writer', write: nil)
      FactGraph.export(writer)
    end
  end
end
