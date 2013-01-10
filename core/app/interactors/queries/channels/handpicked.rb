require 'pavlov'

module Queries
  module Channels
    class Handpicked
      include Pavlov::Query

      arguments

      def execute
        TopChannels.new.members
      end

    end
  end
end
