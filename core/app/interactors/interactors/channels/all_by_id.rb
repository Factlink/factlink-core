require_relative './index.rb'
module Interactors
  module Channels
    class AllById < Index
      arguments :id
      attribute :pavlov_options, Hash, default: {}

      def get_alive_channels
        [Channel[@id]]
      end
    end
  end
end
