module Interactors
  module Channels
    class AddSubchannel
      include Pavlov::Interactor
      include Util::CanCan

      arguments :channel_id, :subchannel_id, :pavlov_options

      def validate
        validate_integer_string :channel_id, channel_id
        validate_integer_string :subchannel_id, subchannel_id
      end

      def execute
        success = old_command :'channels/add_subchannel', channel, subchannel

        if success
          old_command :'channels/added_subchannel_create_activities', channel, subchannel
        end
      end

      def channel
        @channel ||= old_query :'channels/get', channel_id
      end

      def subchannel
        @subchannel ||= old_query :'channels/get', subchannel_id
      end

      def authorized?
        can? :update, channel
      end
    end
  end
end
