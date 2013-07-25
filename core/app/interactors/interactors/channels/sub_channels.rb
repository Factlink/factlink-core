require_relative './index.rb'
module Interactors
  module Channels
    class SubChannels < Index
      arguments :channel
      attribute :pavlov_options, Hash, default: {}

      def get_alive_channels
        @channel.contained_channels
      end
    end
  end
end
