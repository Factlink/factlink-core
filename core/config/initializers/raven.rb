require 'raven'

sentry_conf = YAML::load_file(Rails.root.join('config/sentry.yml')).fetch(Rails.env,{})['sentry']

if sentry_conf
  Raven.configure do |config|
    config.dsn = "https://#{sentry_conf["public"]}:#{sentry_conf["secret"]}@sentry2.factlink.com/#{sentry_conf["project_id"]}"
    config.environments = %w[ staging production ]
    config.excluded_exceptions = ['ActionController::RoutingError', 'CanCan::AccessDenied', 'Pavlov::AccessDenied']
    config.processors = [Raven::Processor::SanitizeData]
  end
end
