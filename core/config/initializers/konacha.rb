if defined?(Konacha)

  puts 'Hello there, I am loading capybara poltergeist'
  puts 'maybe you are surprised to see me. I get loaded a few'
  puts 'times too much. Maybe you should fix me, thx!'

  require 'capybara/poltergeist'
  Konacha.configure do |config|
    config.spec_dir     = "spec/javascripts"
    config.spec_matcher = /_spec\./
    config.driver       = :poltergeist
    config.stylesheets  = []
  end
end
