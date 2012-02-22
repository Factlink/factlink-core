class FrameOptionsHeaders
  def initialize(app)
    @app = app
  end

  def call(env)
    dup._call(env)
  end

  def _call(env)
    status, headers, body = @app.call(env)

    if headers['Content-Type'] =~ /html/ and not env["PATH_INFO"] == "/factlink/intermediate"
      headers['X-Frame-Options'] = "SAMEORIGIN"
    end

    [status, headers, body]
  end
end