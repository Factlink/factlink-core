puts "DEBUG line for CircleCI testing"
if defined?(Konacha)
  require 'rspec'
  Konacha.configure do |config|
    config.spec_dir     = "spec/javascripts"
    config.spec_matcher = /_spec\./
    config.driver       = :poltergeist
    config.stylesheets  = []
  end

  module Konacha
    class Runner
      thin_runner = Module.new do
        def run
          Capybara.server do |app, port|
            require 'rack/handler/thin'
            puts "@@@@@@@@@@@@@@@@@@@@@@@ MANUAL WORKAROUND FOR"
            puts "@@@@ https://github.com/jfirebaugh/konacha/issues/146"
            Rack::Handler::Thin.run(app, :Port => port)
          end
          super()
        end
      end
      prepend thin_runner
    end
  end
end
