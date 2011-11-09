module Channels
  class ContainedChannelList < Mustache::Railstache
    def channels
      self[:channels].graph_user.channels.map do |ch|
        channel_path(channel.created_by.user.username, @channel.id)
        ch.class_eval """
          def link
            #{channel_path}
          end
        """
        ch
      end
    end

  end
end
