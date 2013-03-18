namespace :konacha do
  task :load_poltergeist => :environment do
    require 'capybara/poltergeist'
  end
end
