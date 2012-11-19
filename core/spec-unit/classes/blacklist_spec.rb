require_relative '../../app/classes/blacklist.rb'
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
      regex.match('http://foo.com').should be_true
      regex.match('http://foo.com/').should be_true
      regex.match('https://foo.com/').should be_true
      regex.match('https://fooacom/').should be_false
    end

    it "should match subdomains" do
      regex.match('http://bar.foo.com').should be_true
      regex.match('http://bar.foo.com/').should be_true
      regex.match('http://barfoo.com/').should be_false
      regex.match('http://bar.com/arg.foo.com/').should be_false
    end
  end

  describe ".strict_domain" do
    let(:regex) {Blacklist.strict_domain('foo.com')}

    it "should match the domain" do
      regex.match('http://foo.com').should be_true
      regex.match('http://foo.com/').should be_true
      regex.match('https://foo.com/').should be_true
      regex.match('https://fooacom/').should be_false
    end
    it "should not match subdomains" do
      regex.match('http://bar.foo.com').should be_false
      regex.match('http://bar.foo.com/').should be_false
    end
  end

  describe ".default" do
    let(:defaultlist) { Blacklist.default }
    it "should match factlink.com" do
      defaultlist.matches?('https://factlink.com/').should be_true
    end
    it "should not match blog.factlink.com" do
      defaultlist.matches?('https://blog.factlink.com/').should be_false
    end
    it "should match facebook.com" do
      defaultlist.matches?('https://facebook.com/').should be_true
    end
  end

end
