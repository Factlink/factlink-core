module Interactors
  module Channels
    class AddSubchannel
      include Pavlov::Interactor

      arguments :channel_id, :subchannel_id

      def execute
        # raise 'not found' unless channel and subchannel
        channel.add_channel subchannel
      end

      def channel
        @channel ||= Channel[channel_id]
      end

      def subchannel
        @subchannel ||= Channel[subchannel_id]
      end

      def authorized?
        true
      end
    end
  end
end
