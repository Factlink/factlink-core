require File.expand_path('../../../app/classes/blacklist.rb', __FILE__)

describe Blacklist do
  subject {
    Blacklist.new([
      /^http(s)?:\/\/([^\/]+\.)?facebook\.com/,
      /^http(s)?:\/\/([^\/]+\.)?factlink\.com/,
      /^http(s)?:\/\/([^\/]+\.)?twitter\.com/,
    ])
  }

  describe "#should_return_true_on_match" do
    it {subject.matches?('http://facebook.com').should == true}
  end

  describe "#should_return_false_when_no_match" do
    it {subject.matches?('http://google.com').should == false}
  end

  describe "#should_also_match_non-first_blacklist_item" do
    it {subject.matches?('http://twitter.com').should == true}
    it {subject.matches?('http://factlink.com').should == true}
  end

  describe "#should_also_match_subdomains" do
    it {subject.matches?('http://static.demo.factlink.com').should == true}
    it {subject.matches?('http://demo.factlink.com').should == true}
  end

  describe ".domain" do
    let(:regex) {Blacklist.domain('foo.com')}

    it "should match the domain" do
      regex.match('http://foo.com/').should be_true
      regex.match('https://foo.com/').should be_true
      regex.match('https://fooacom/').should be_false
    end

    it "should match subdomains" do
      regex.match('http://bar.foo.com/').should be_true
      regex.match('http://barfoo.com/').should be_false
      regex.match('http://bar.com/arg.foo.com/').should be_false
    end
  end

end