module Channels
  class ContainedChannelList < Mustache::Railstache
    def channels_with_link
      self[:channels].to_a.map do |ch|
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
