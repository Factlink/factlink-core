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
