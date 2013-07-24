module Commands
  module Channels
    class Follow
      include Pavlov::Command

      arguments :channel, :pavlov_options

      def execute
        success = old_command :'channels/add_subchannel', follower, channel

        success ? follower : nil
      end

      def follower
        @follower ||= old_query(:'channels/get_by_slug_title', channel.slug_title) ||
          old_command(:'channels/create', channel.title)
      end

      def authorized?
         # this is no stub, every user can follow another channel
        pavlov_options[:current_user]
      end
    end
  end
end
