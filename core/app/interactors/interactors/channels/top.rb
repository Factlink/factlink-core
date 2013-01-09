require_relative './index.rb'

module Interactors
  module Channels
    class Top < Index
      arguments

      def get_alive_channels
        handpicked_channels.sample(12)
      end

      def handpicked_channels
        query :"channels/handpicked"
      end
    end
  end
end
