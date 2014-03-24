require 'spec_helper'
require_relative '../../lib/url_validator'

describe UrlValidator do
  describe "#valid?" do
    it "is false when url is nil" do
      validator = UrlValidator.new(nil)
      expect(validator.valid?).to be_falsey
    end
    it "is false when url is invalid" do
      validator = UrlValidator.new("10://henk/")
      expect(validator.valid?).to be_falsey
    end

    it "is false when url is empty" do
      validator = UrlValidator.new("")
      expect(validator.valid?).to be_falsey
    end

    it "is true when url is a regular http url" do
      validator = UrlValidator.new("http://example.org/foo?bar=baz")
      expect(validator.valid?).to be_truthy
    end

    it "is true when url is a regular https url" do
      validator = UrlValidator.new("https://example.org/foo?bar=baz")
      expect(validator.valid?).to be_truthy
    end

    it "is false when url has a non-http scheme" do
      validator = UrlValidator.new("ftp://example.org/foo")
      expect(validator.valid?).to be_falsey
    end

    it "is false for localhost" do
      validator = UrlValidator.new("http://localhost/foo")
      expect(validator.valid?).to be_falsey
    end

    it "is false for any local-ish hostnames without dots" do
      validator = UrlValidator.new("http://otherhost/foo")
      expect(validator.valid?).to be_falsey
    end

    it "is false for any hostnames ending in a dot" do
      validator = UrlValidator.new("http://example.org./foo")
      expect(validator.valid?).to be_falsey
    end

    it "is false for 127.0.0.1" do
      validator = UrlValidator.new("http://127.0.0.1/foo")
      expect(validator.valid?).to be_falsey
    end

    it "is false for pow urls" do
      validator = UrlValidator.new("http://local_app.dev")
      expect(validator.valid?).to be_falsey
    end

    # http://en.wikipedia.org/wiki/Reserved_IP_addresses
    # private ips are forbidden
    private_ips = [
      "10.4.5.6",
      "100.64.1.2",
      "100.127.255.255",
      "172.16.0.0",
      "172.31.255.255",
      "192.0.0.0",
      "192.0.0.7",
      "192.168.0.0",
      "192.168.255.255",
      "198.18.0.0",
      "198.19.255.255",
    ]
    private_ips.each do |ip|
      it "is false for local ips of form #{ip}" do
        validator = UrlValidator.new("http://#{ip}/foo?bar=baz")
        expect(validator.valid?).to be_falsey
      end
    end

    it "is true for a regular ip like 129.125.61.85" do
      validator = UrlValidator.new("http://129.125.61.85/foo?bar=baz")
      expect(validator.valid?).to be_truthy
    end

    it "is false for ipv6" do
      validator = UrlValidator.new("http://3ffe:1900:4545:3:200:f8ff:fe21:67cf/foo?bar=baz")
      expect(validator.valid?).to be_falsey
    end
  end

  describe "#normalized" do
    it "strips port 80 for http" do
      validator = UrlValidator.new("http://example.org:80/foo?bar=baz")
      expect(validator.normalized).to eq "http://example.org/foo?bar=baz"
    end

    it "strips port 443 for http" do
      validator = UrlValidator.new("https://example.org:443/foo?bar=baz")
      expect(validator.normalized).to eq "https://example.org/foo?bar=baz"
    end

    it "strips http auth usernames/passwords" do
      validator = UrlValidator.new("https://foo:bar@example.org/foo?bar=baz")
      expect(validator.normalized).to eq "https://example.org/foo?bar=baz"
    end
  end

end
