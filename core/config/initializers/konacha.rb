if defined?(Konacha)
  Konacha.configure do |config|
    config.spec_dir     = "spec/javascripts"
    config.spec_matcher = /_spec\./
    config.driver       = :poltergeist
    config.stylesheets  = []
  end
end
