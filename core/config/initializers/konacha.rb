if defined?(Konacha)
  require 'rspec'
  Konacha.configure do |config|
    config.spec_dir     = "spec/javascripts"
    config.spec_matcher = /_spec\./
    config.driver       = :poltergeist
    config.stylesheets  = []
    if ENV['JENKINS_URL']
      require 'rspec_junit_formatter'
      config.formatters = [
        RspecJunitFormatter.new(
          File.new('tmp/konacha.junit.xml', 'a')
        )]
    end
  end
end
