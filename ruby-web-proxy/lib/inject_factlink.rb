class InjectFactlink
  include Goliath::Rack::AsyncMiddleware

  def post_process(env, status, headers, body)
    if status == 200
      body.gsub!(/<\/head>/, factlink_scripttag + '</head>')
    end
    [status, headers, body]
  end

  def factlink_scripttag
    '<!-- SLASH HEAD -->'
  end
end
