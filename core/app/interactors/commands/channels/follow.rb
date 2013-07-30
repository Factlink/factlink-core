module Commands
  module Channels
    class Follow
      include Pavlov::Command

      arguments :channel

      def execute
        success = old_command :'channels/add_subchannel', follower, channel

        success ? follower : nil
      end

      def follower
        @follower ||= query(:'channels/get_by_slug_title', channel.slug_title) ||
          command(:'channels/create', channel.title)
      end

      def authorized?
         # this is no stub, every user can follow another channel
        pavlov_options[:current_user]
      end
    end
  end
end
