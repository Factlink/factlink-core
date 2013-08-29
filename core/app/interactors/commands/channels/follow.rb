module Commands
  module Channels
    class Follow
      include Pavlov::Command

      arguments :channel

      def execute
        success = command(:'channels/add_subchannel',
                              channel: follower, subchannel: channel)

        success ? follower : nil
      end

      def follower
        @follower ||= query(:'channels/get_by_slug_title', slug_title: channel.slug_title) ||
          command(:'channels/create', title: channel.title)
      end

      def authorized?
         # this is no stub, every user can follow another channel
        pavlov_options[:current_user]
      end
    end
  end
end
