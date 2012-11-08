require 'raven'

if [:testserver, :staging, :production].include?(Rails.env)

  sentry_conf = YAML::load_file(Rails.root.join('config/sentry.yml'))[Rails.env]['sentry']

  Raven.configure do |config|
    config.dsn = "http://#{sentry_conf[:public]}:#{sentry_conf[:secret]}@example.com/#{sentry_conf[:project_id]}"
    config.processors = [Raven::Processor::SanitizeData]
  end
end
