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
    image = image_tag "team/#{photo}.png", alt: name, class: "tooltips", rel: "tooltip", title: name, width: 82, height: 82
    if linkedin
      linkedin_url = linkedin.match(/^http/) ? linkedin : "http://www.linkedin.com/in/#{linkedin}"
      link_to image, linkedin_url, target: "_blank"

    else
      image
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
