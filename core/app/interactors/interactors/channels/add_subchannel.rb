module Interactors
  module Channels
    class AddSubchannel
      include Pavlov::Interactor
      include Util::CanCan

      arguments :channel_id, :subchannel_id

      def validate
        validate_integer_string :channel_id, channel_id
        validate_integer_string :subchannel_id, subchannel_id
      end

      def execute
        # raise 'not found' unless channel and subchannel
        command :'channels/add_subchannel', channel, subchannel
      end

      def channel
        @channel ||= Channel[channel_id]
      end

      def subchannel
        @subchannel ||= Channel[subchannel_id]
      end

      def authorized?
        can? :update, channel
      end
    end
  end
end
