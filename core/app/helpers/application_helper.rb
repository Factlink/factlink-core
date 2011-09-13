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
end
