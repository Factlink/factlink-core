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
      begin
        Raven.captureMessage(message)
      rescue
        stdout_logger.error("Could not connect to Sentry")
      end
    end

    super(severity, message, progname)
  end

  def stdout_logger
    @stdout_logger ||= Logger.new(STDOUT)
  end

end
