require_relative './index.rb'

module Interactors
  module Channels
    class Top < Index
      arguments :count

      def get_alive_channels
        handpicked_channels.sample(@count)
      end

      def handpicked_channels
        query :"channels/handpicked"
      end
    end
  end
end
