class UrlNormalizer
  class ThinkProgress < UrlNormalizer
    normalize_for 'thinkprogress.org'
    normalize_for 'www.thinkprogress.org'

    def forbidden_uri_params
      super + [:mobile]
    end
  end
end
