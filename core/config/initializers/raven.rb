require 'raven'

sentry_conf = YAML::load_file(Rails.root.join('config/sentry.yml'))[Rails.env].andand['sentry']

if sentry_conf
  Raven.configure do |config|
    config.dsn = "https://#{sentry_conf["public"]}:#{sentry_conf["secret"]}@sentry2.factlink.com/#{sentry_conf["project_id"]}"
    config.environments = %w[ testserver staging production ]
    config.excluded_exceptions = ['ActionController::RoutingError', 'CanCan::AccessDenied', 'Pavlov::AccessDenied']
    config.processors = [Raven::Processor::SanitizeData]
  end

  Moped::Connection.class_eval do
    alias :unchecked_connect :connect unless method_defined?(:unchecked_connect)

    def stdout_logger
      @stdout_logger ||= Logger.new(STDOUT)
    end

    def connect
      unchecked_connect
    rescue StandardError => exception
      begin
        Raven.captureException(exception)
      rescue
        stdout_logger.error("Could not connect to Sentry")
      end
      raise
    end
  end
end
