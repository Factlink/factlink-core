module Channels
  class ContainedChannelList < Mustache::Railstache
    def channels_with_link
      self[:channels].to_a.map do |ch|
        user = ch.created_by.user
        ch_path = channel_path(user.username, ch.id)
        user_path = channel_path(user.username)
        ch.class_eval """
          def link
            '#{escape_single_quotes(ch_path)}'
          end
          
          def user_link
            '#{escape_single_quotes(user_path)}'
          end
          
          def user_avatar
            '#{escape_single_quotes(user.avatar.url(:thumb))}'
          end
          
          def username
            '#{escape_single_quotes(user.username)}'
          end
        """
        ch
      end
    end
    def escape_single_quotes(s)
      s.gsub(/'/, "\\\\'")
    end
  end
end
