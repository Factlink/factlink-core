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
        command :'channels/add_subchannel', channel, subchannel
      end

      def channel
        @channel ||= get_channel(channel_id)
      end

      def subchannel
        @subchannel ||= get_channel(subchannel_id)
      end

      def get_channel id
        Channel[id] or raise "Channel #{id} not found"
      end

      def authorized?
        can? :update, channel
      end
    end
  end
end
