module ApplicationHelper
  def image_url(source)
    abs_path = image_path(source)
    unless abs_path =~ /^http/
      abs_path = "#{request.protocol}#{request.host_with_port}#{abs_path}"
    end
    abs_path
  end

  # This is included in rails 3.1.0, and now we're forwards compatible ;)
  # TODO remove when upgrading to 3.1
  # File actionpack/lib/action_view/helpers/form_tag_helper.rb, line 458
  def button_tag(content_or_options = nil, options = nil, &block)
    options = content_or_options if block_given? && content_or_options.is_a?(Hash)
    options ||= {}
    options.stringify_keys!

    if disable_with = options.delete("disable_with")
      options["data-disable-with"] = disable_with
    end

    if confirm = options.delete("confirm")
      options["data-confirm"] = confirm
    end

    options.reverse_merge! 'name' => 'button', 'type' => 'submit'

    content_tag :button, content_or_options || 'Button', options, &block
  end
  
  def template_as_string(filename)
    data = ''
    filename = Rails.root.join('app','views',filename)
    File.open(filename, "r") do |f|
      f.each_line do |line|
        data += line
      end
    end
    return data.html_safe
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