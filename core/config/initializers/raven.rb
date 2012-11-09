require 'raven'

sentry_conf = YAML::load_file(Rails.root.join('config/sentry.yml'))[Rails.env].andand['sentry']

if sentry_conf
  Raven.configure do |config|
    config.dsn = "http://#{sentry_conf["public"]}:#{sentry_conf["secret"]}@sentry.factlink.com/#{sentry_conf["project_id"]}"
    config.environments = %w[ testserver staging production ]
    config.processors = [Raven::Processor::SanitizeData]
  end
end
