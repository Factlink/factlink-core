class UrlNormalizer
  class Newyorker < UrlNormalizer
    normalize_for 'newyorker.com'
    normalize_for 'www.newyorker.com'

    def forbidden_uri_params
      super + [:mobify]
    end
  end
end
