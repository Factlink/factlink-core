# config/initializers/resque_mailer.rb
Resque::Mailer.excluded_environments = [:test, :develop]