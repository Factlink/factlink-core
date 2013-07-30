require_relative './index.rb'
module Interactors
  module Channels
    class SubChannels < Index
      arguments :channel

      def get_alive_channels
        @channel.contained_channels
      end
    end
  end
end
