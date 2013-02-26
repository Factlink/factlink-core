require 'spec_helper'

describe QueryParams do
  describe :[] do
    it "should get the param" do
      q = QueryParams.new('http://example.org/?foo=bar')
      expect(q[:foo]).to eq 'bar'
    end
  end
end
