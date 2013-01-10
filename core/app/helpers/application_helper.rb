module ApplicationHelper
  def image_url(source)
    abs_url(image_path(source))
  end

  def t_up(*args)
    string = t(*argstring)
    string[0] = string[0].upcase
    string
  end

  def abs_url(path)
    unless path =~ /^http/
      path = "#{request.protocol}#{request.host_with_port}#{path}"
    end
    path
  end

  def template_as_string(filename)
    data = ''
    filename = Rails.root.join('app','templates',filename)
    File.open(filename, "r") do |f|
      f.each_line do |line|
        data += line
      end
    end
    return data.html_safe
  end

  def render_mustache(*args)
    render(*args).html_safe
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

  def show_active_step step_in_signup_proces, step
    if step_in_signup_proces == step
      " class='active'"
    end
  end

  def home_path
    if user_signed_in?
      channel_activities_path(current_user.username,current_graph_user.stream_id)
    else
      '/'
    end
  end

end
