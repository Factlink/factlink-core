require File.expand_path('../../../app/classes/js_lib_url.rb', __FILE__)
require 'uri'
require 'rspec/matchers'

RSpec::Matchers.define :be_a_valid_url do
  match do |url|
    not (url =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]).nil?
  end
end


describe :JsLibUrl do
  describe :username do
    it "gives the username" do
      url = JsLibUrl.new 'mark'
      url.username.should == 'mark'
    end
  end

  describe :== do
    it 'returns true for urls for the same user' do
      url1 = JsLibUrl.new 'mark'
      url2 = JsLibUrl.new 'mark'
      (url1 == url2).should be_true
    end

    it 'returns false for different objects' do
      url1 = JsLibUrl.new 'mark1'
      url2 = JsLibUrl.new 'mark2'
      (url1 == url2).should be_false
    end
  end

  describe :to_s do
    it 'should be a valid url' do
      url = JsLibUrl.new 'mark'
      url.to_s.should be_a_valid_url
    end
    it 'does not contain the username' do
      url = JsLibUrl.new 'mark'
      url.to_s.should_not match /mark/
    end
  end

  describe '#from_string' do
    it "gives the object back from the username" do
      ['mark','tom'].each do |username|
        url = JsLibUrl.new username
        url.should == JsLibUrl.from_string(url.to_s)
      end
    end
  end
end