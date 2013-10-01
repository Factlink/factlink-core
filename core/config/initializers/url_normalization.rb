# Monkey patch to also rewrite urls for our staging and testserver
class UrlNormalizer
  class Proxy < UrlNormalizer
    normalize_for 'testserver.fct.li'
    normalize_for 'staging.fct.li'
  end
end
