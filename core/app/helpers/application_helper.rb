module ApplicationHelper
  def image_url(source)
    abs_url(image_path(source))
  end
  
  def javascript_url(source)
    abs_url(javascript_path(source))
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
    p = '<script type="text/html" id="#{id}">'
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