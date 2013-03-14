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
        # raise 'not found' unless channel and subchannel
        command :'channels/remove_subchannel', channel, subchannel
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
