module ChannelsHelper
  
  def add_channel(user)
    if user_signed_in?
      if current_user == user
        render :partial => "channels/add_channel"
      end
    end
  end
  class MenuItemView
    include Rails.application.routes.url_helpers    

    def initialize(channel,jsmode)
      @channel = channel
      @jsmode = jsmode
    end

    def channel_link
      return @jsmode ? "/\<%= username %\>/channels/\<%= channel.id %\>/facts".html_safe : facts_for_channel_path(@channel.created_by.user.username, @channel)
    end
    def title
      @jsmode ? "\<%= channel.title %\>".html_safe : @channel.title
    end
    def nr_of_facts
      return @jsmode ? "\<%= channel.facts.length %\>".html_safe : @channel.facts.count
    end
  end
end
