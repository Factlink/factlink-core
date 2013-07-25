module Commands
  module Channels
    class AddSubchannel
      include Pavlov::Command

      arguments :channel, :subchannel
      attribute :pavlov_options, Hash, default: {}

      def execute
        success = channel.add_channel(subchannel)

        if success
          old_command :'channels/add_facts_from_channel_to_channel', subchannel, channel
        end

        success
      end
    end
  end
end
