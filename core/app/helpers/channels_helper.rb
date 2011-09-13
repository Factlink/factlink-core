module ChannelsHelper
  
  def fork_label(channel)
    if channel.created_by == current_user.graph_user
      return "duplicate"
    else
      return "add to my channels"
    end
  end
  
  def button_for(name, options={})
    return content_tag(:button, content_tag(:span, content_tag(:span, name)), :class => options[:class], :type => options[:button_type])
  end
  
end
