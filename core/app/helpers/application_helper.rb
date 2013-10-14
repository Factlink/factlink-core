# This helper contains application wide helpers
# There shouldn't be anything specific in this file.
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
    if path =~ /^http/
      path
    else
      "#{request.protocol}#{request.host_with_port}#{path}"
    end
  end

  def minify_js(s)
    res = s
    res = res.gsub(/^\s*\/\/[^\n]*\n/, '')
    res = res.gsub(/\s+/, ' ')
    res.html_safe
  end

  def ensure_no_single_quotes(s)
    fail "Please do not use single quotes here" if s.match(/'/)
    s
  end

  def home_path
    if user_signed_in?
      feed_path(current_user.username)
    else
      '/'
    end
  end

end
