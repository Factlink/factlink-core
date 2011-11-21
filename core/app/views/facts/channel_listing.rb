module Facts
  class ChannelListing < Mustache::Railstache
    def current_graph_user
      @current_graph_user ||= self[:current_user].graph_user
    end
    
    def channels
      current_graph_user.editable_channels_for(self[:fact])
    end
  
    def channel_path
      channels_path(@current_user.username)
    end
      
  end
end
