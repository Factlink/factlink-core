require 'spec_helper'

describe FactlinkSearcher do
  
  before(:each) do
    @searcher = FactlinkSearcher.new
  end
  
  it "should return 0 results when searching for 'Salvatore'" do
    @searcher.search('Salvatore').results.count.should == 0
  end

  it "should return 'development'" do
    @searcher.env.should == "development"
  end

  it "should return 1 results when searching for '1960s'" do
    @searcher.search('1960s').results.count.should == 101
  end
  
  it "should return 4 results when searching for 'Batman'" do
    @searcher.search('Batman').results.count.should == 404
  end
  
end