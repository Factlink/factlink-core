module Interactors
  module Channels
    class RemoveSubchannel
      include Pavlov::Interactor
      include Util::CanCan

      arguments :channel_id, :subchannel_id

      def validate
        validate_integer_string :channel_id, channel_id
        validate_integer_string :subchannel_id, subchannel_id
      end

      def execute
        success = command :'channels/remove_subchannel', channel, subchannel
        if success
          channel.activity(channel.created_by, :removed, subchannel, :to, channel)
        end
      end

      def channel
        @channel ||= query :'channels/get', channel_id
      end

      def subchannel
        @subchannel ||= query :'channels/get', subchannel_id
      end

      def authorized?
        can? :update, channel
      end
    end
  end
end
