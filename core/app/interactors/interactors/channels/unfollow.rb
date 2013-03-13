module Interactors
  module Channels
    class Unfollow
      include Pavlov::Interactor

      arguments :channel_id

      def validate
        validate_integer_string :channel_id, channel_id
      end

      def execute
        following_channels.each do |follower|
          command :'channels/remove_subchannel', follower, channel
        end
      end

      def following_channels
        channel_ids = query :containing_channel_ids_for_channel_and_user, channel.id, @options[:current_user].graph_user_id

        channel_ids.map {|id| Channel[id]}
      end

      def channel
        @channel ||= Channel[channel_id]
      end

      def authorized?
         # this is no stub, every user can unfollow another channel
        @options[:current_user]
      end

    end
  end
end
