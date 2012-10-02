class UrlNormalizer
  class NewYorkTimes < UrlNormalizer
    normalize_for 'nytimes.com'
    normalize_for 'www.nytimes.com'

    def forbidden_uri_params
      super + [:_r]
    end

    def whitelisted_uri_params
      [:pagewanted]
    end

  end
end