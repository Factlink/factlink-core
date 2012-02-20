module Facts
  class ChannelListing < Mustache::Railstache
    expose_to_hash :current_graph_user

    def channels
      current_graph_user.editable_channels_for(self[:fact])
    end

    def channel_path
      channels_path(current_user.username)
    end

  end
end
