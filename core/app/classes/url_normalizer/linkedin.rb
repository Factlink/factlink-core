class UrlNormalizer
  class LinkedIn < UrlNormalizer
    normalize_for 'linkedin.com'
    normalize_for 'www.linkedin.com'

    def forbidden_uri_params
      super + [:ref]
    end
  end
end
