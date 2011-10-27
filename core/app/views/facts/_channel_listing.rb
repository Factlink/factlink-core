module Facts
  class ChannelListing < Mustache::Rails
    def channels
      self[:current_user].graph_user.channels.map do |ch|
        if ch.include?(self[:fact])
          def ch.checked_attribute; 'checked="checked"' end
        else
          def ch.checked_attribute; '' end
        end
        ch
      end
    end
    def channel_path
      channels_path(@current_user.username)
    end
    def id
      self[:fact].id
    end
    
  end
end