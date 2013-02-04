require 'raven'

sentry_conf = YAML::load_file(Rails.root.join('config/sentry.yml'))[Rails.env].andand['sentry']

if sentry_conf
  Raven.configure do |config|
    config.dsn = "https://#{sentry_conf["public"]}:#{sentry_conf["secret"]}@sentry.factlink.com/#{sentry_conf["project_id"]}"
    config.environments = %w[ testserver staging production ]
    config.excluded_exceptions = ['ActionController::RoutingError']
    config.processors = [Raven::Processor::SanitizeData]
  end

  Moped::Connection.class_eval do
    alias :unchecked_connect :connect unless method_defined?(:unchecked_connect)
    def connect
      unchecked_connect
    rescue StandardError => exception
      Raven.captureException(exception, level: 'info')
      raise
    end
  end
end
