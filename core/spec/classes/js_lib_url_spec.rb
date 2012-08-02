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
      url.to_s.should_not include 'mark'
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

  describe '#salt=' do
    it 'makes the url encode to a different url' do
      url1_string = JsLibUrl.new( 'mark').to_s
      url2_string = JsLibUrl.new( 'mark', salt: 'hoi').to_s
      url1_string.should_not == url2_string
    end
  end

  describe '#base_url=' do
    it 'should set the first part of the url' do
      ['http://example.org/', 'http://example.com/'].each do |base_url|
        JsLibUrl.new('mark', base_url: base_url).to_s.should start_with base_url
      end
    end
  end
end