module Channels
  class ContainedChannelList < Mustache::Railstache
    def channels_with_link
      self[:channels].to_a.map do |ch|
        ch_path = channel_path(ch.created_by.user.username, ch.id)
        ch.class_eval """
          def link
            '#{ch_path}'
          end
        """
        ch
      end
    end

  end
end
