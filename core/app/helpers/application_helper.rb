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

  def home_path
    if user_signed_in?
      feed_path(current_user.username)
    else
      '/'
    end
  end

end
