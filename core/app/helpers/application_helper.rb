module ApplicationHelper
  def image_url(source)
    abs_url(image_path(source))
  end

  def t_up(*args)
    string = t(*args)
    string[0] = string[0].upcase
    string
  end

  def abs_url(path)
    unless path =~ /^http/
      path = "#{request.protocol}#{request.host_with_port}#{path}"
    end
    path
  end

  def minify_js(s)
    res = s
    res = res.gsub(/^\s*\/\/[^\n]*\n/, '')
    res = res.gsub(/\s+/, ' ')
    res.html_safe
  end

  def ensure_no_single_quotes(s)
    raise "Please do not use single quotes here" if s.match(/'/)
    s
  end

  def home_path
    if user_signed_in?
      channel_activities_path(current_user.username,current_graph_user.stream_id)
    else
      '/'
    end
  end

end
