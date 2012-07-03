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

  def load_js_template(id, filename)
    p = "<script type='text/html' id='#{id}'>"
    p += template_as_string filename
    p += "</script>"
    p.html_safe
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
    image = image_tag "team/#{photo}.png", alt: name, class: "tooltips", rel: "tooltip", title: name, width: 82, height: 82
    if linkedin
      linkedin_url = linkedin.match(/^http/) ? linkedin : "http://www.linkedin.com/in/#{linkedin}"
      link_to image, linkedin_url, target: "_blank"

    else
      image
    end
  end

  def logo_click_path
    if user_signed_in?
      activities_channel_path(current_user.username,current_graph_user.stream_id) + "?click=logo"
    else
      '/'
    end
  end

  def home_click_path
    if user_signed_in?
      activities_channel_path(current_user.username,current_graph_user.stream_id) + "?click=home"
    else
      '/'
    end
  end

  def brain_icon
    image_tag image_path("brain.png")
  end

  def time_ago_short(time)
    a = (Time.now-time).to_i

    case a
      when 0..119 then return '1m' #120 = 2 minutes
      when 120..3540 then return (a/60).to_i.to_s+'m'
      when 3541..7100 then return '1h' # 3600 = 1 hour
      when 7101..82800 then return ((a+99)/3600).to_i.to_s+'h'
      when 82801..172000 then return '1d' # 86400 = 1 day
      when 172001..518400 then return ((a+800)/(60*60*24)).to_i.to_s+'d'
      when 518400..1036800 then return '1w'
    end
    return ((a+180000)/(60*60*24*7)).to_i.to_s+'w'
  end

end

# http://stackoverflow.com/questions/4814631/how-to-disable-link-to-remote-funcation-after-click-made/7415741#7415741
module ActionView
  module Helpers
    module UrlHelper
      def link_to_with_disable(*args, &block)
        if block_given?
          link_to_without_disable(*args,&block)
        else
          html_options = args[2] || {}
          disable_with = html_options[:disable_with]
          if disable_with
            if html_options[:disable_with].kind_of? String
              html_options[:"data-onloadingtext"] = disable_with
            elsif html_options[:disable_with].kind_of? Array
              html_options[:"data-onloadingtext"] = disable_with[0] if disable_with[0]
              html_options[:"data-oncompletetext"] = disable_with[1] if disable_with[1]
            end
          end
          link_to_without_disable(*args)
        end
      end
      alias_method_chain :link_to, :disable unless method_defined?(:link_to_without_disable)
    end
  end
end
