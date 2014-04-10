require 'spec_helper'

describe FactlinkImport do
  it "doesn't crash in our setup" do
    require File.expand_path('../../../dump.rb', __FILE__)
  end
end
