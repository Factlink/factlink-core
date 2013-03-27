module Interactors
  module Channels
    class Follow
      include Pavlov::Interactor

      arguments :channel_id

      def validate
        validate_integer_string :channel_id, channel_id
      end

      def execute
        follower = command :'channels/follow', channel
        if follower
          command :'channels/added_subchannel_create_activities', follower, channel
        end
      end

      def channel
        @channel ||= query :'channels/get', channel_id
      end

      def authorized?
         # this is no stub, every user can follow another channel
        @options[:current_user]
      end
    end
  end
end
