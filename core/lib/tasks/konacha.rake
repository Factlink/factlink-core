namespace :konacha do
  task :load_poltergeist => :environment do
    require 'capybara/poltergeist'
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, { timeout: 60 })
    end
  end
end
