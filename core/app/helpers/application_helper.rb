module ApplicationHelper
  def image_url(source)
    abs_url(image_path(source))
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
    res = res.gsub /^\s*\/\/[^\n]*\n/, ''
    res = res.gsub /\s+/, ' '
    res.html_safe
  end

  def ensure_no_single_quotes(s)
    raise "Please do not use single quotes here" if s.match /'/
    s
  end

  def team_photo_tag photo, name, linkedin=nil
    html = image_tag "team/#{photo}.png", alt: name, class: "img-polaroid", rel: "tooltip", title: name, width: 120, height: 120

    if linkedin
      linkedin_url = linkedin.match(/^http/) ? linkedin : "http://www.linkedin.com/in/#{linkedin}"
      html = link_to html, linkedin_url, target: "_blank"
    end

    html = content_tag "div", html, class: "span3"

    html
  end

  def show_active_step step
    if @step_in_signup_proces == step
      " class='active'"
    end
  end

  def click_path(action)
    if user_signed_in?
      channel_activities_path(current_user.username,current_graph_user.stream_id) + "?ref=#{action}"
    else
      '/'
    end
  end

end
