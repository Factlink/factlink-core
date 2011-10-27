require 'active_support/configurable'

module ChannelsHelper
  
  def add_channel(user)
    if user_signed_in?
      if current_user == user
        render :partial => "channels/add_channel"
      end
    end
  end

  class ChannelModelView
      include Rails.application.routes.url_helpers    
    #default_url_options[:host] = 'localhost:3000'
    
    def initialize(channel,jsmode=false)
      @channel = channel
      @jsmode = jsmode
    end

    def link
      return get_facts_for_channel_path(@channel.created_by.user.username, @channel)
    end
    
    def title
      @channel.title
    end
    
    def nr_of_facts
      @channel.facts.count
    end
    
    def id
      @channel.id
    end
    
    def to_hash
      return {
                 :id => id,
               :link => link,
              :title => title,
        :nr_of_facts => nr_of_facts,
      }
    end
  end
end
