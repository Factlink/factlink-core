require_relative '../../../app/classes/url_normalizer.rb'
require 'uri'
require 'base64'

describe UrlNormalizer do
  describe ".normalize" do
    def normalized url
      UrlNormalizer.normalize(url)
    end
    it {normalized('http://thinkprogress.org/politics/2012/08/17/705401/how-paul-ryans-budget-would-devastate-social-programs-for-todays-lower-income-americans/?mobile=nc').should ==
                   'http://thinkprogress.org/politics/2012/08/17/705401/how-paul-ryans-budget-would-devastate-social-programs-for-todays-lower-income-americans/'}
  end
end
