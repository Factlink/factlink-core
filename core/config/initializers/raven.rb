require 'raven'

sentry_conf = YAML::load_file(Rails.root.join('config/sentry.yml'))[Rails.env].andand['sentry']

if sentry_conf

  class RavenLogger < Logger

    attr_accessor :raven_level

    def raven_minimum_level
      @raven_level || WARN
    end

    def add(severity, message = nil, progname = nil, &block)
      # Copied from Ruby's lib/logger.rb
      severity ||= UNKNOWN
      if @logdev.nil? or severity < @level
        return true
      end
      progname ||= @progname
      if message.nil?
        if block_given?
          message = yield
        else
          message = progname
          progname = @progname
        end
      end
      # End copy

      if severity >= raven_minimum_level
        Raven.capture_message(message)
      end

      super(severity, message, progname)
    end

  end

  Raven.configure do |config|
    config.dsn = "https://#{sentry_conf["public"]}:#{sentry_conf["secret"]}@sentry2.factlink.com/#{sentry_conf["project_id"]}"
    config.environments = %w[ testserver staging production ]
    config.excluded_exceptions = ['ActionController::RoutingError']
    config.processors = [Raven::Processor::SanitizeData]
  end

  Moped::Connection.class_eval do
    alias :unchecked_connect :connect unless method_defined?(:unchecked_connect)
    def connect
      unchecked_connect
    rescue StandardError => exception
      begin
        Raven.captureException(exception)
      rescue
        Rails.logger.error("Could not connect to Sentry")
      end
      raise
    end
  end

  Moped.logger = RavenLogger.new(STDOUT)
end
