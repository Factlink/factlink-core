if defined?(Konacha)
  require 'capybara/poltergeist'
  Konacha.configure do |config|
    config.spec_dir     = "spec/javascripts-konacha"
    config.spec_matcher = /_spec\./
    config.driver       = :poltergeist
    config.stylesheets  = []
  end
end
