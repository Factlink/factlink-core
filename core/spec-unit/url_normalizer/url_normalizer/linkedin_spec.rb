require_relative '../../../app/classes/url_normalizer.rb'
require 'uri'
require 'base64'

describe UrlNormalizer do
  describe ".normalize" do
    def normalized url
      UrlNormalizer.normalize(url)
    end
    it {normalized('http://www.linkedin.com/today/post/article/20130131131416-174077701-lessons-from-my-bosses?ref=email').should ==
                   'http://www.linkedin.com/today/post/article/20130131131416-174077701-lessons-from-my-bosses'}
  end
end
