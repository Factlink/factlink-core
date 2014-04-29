# Monkey patch to also rewrite urls for our staging server
class UrlNormalizer
  class Proxy < UrlNormalizer
    normalize_for 'staging.fct.li'
  end
end
