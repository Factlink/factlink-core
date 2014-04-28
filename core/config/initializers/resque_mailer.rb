# config/initializers/resque_mailer.rb
Resque::Mailer.excluded_environments = [:test]
Resque::Mailer.default_queue_name = "bbb_mailer"
