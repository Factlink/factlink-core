if defined?(Konacha)
  require 'rspec'
  require 'ci/reporter/rake/rspec_loader'
  require 'yarjuf'
  Konacha.configure do |config|
    config.spec_dir     = "spec/javascripts"
    config.spec_matcher = /_spec\./
    config.driver       = :poltergeist
    config.stylesheets  = []
  end
end
