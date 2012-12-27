require_relative './index.rb'
module Interactors
  module Channels
    class TopForTopic < Index
      arguments :topic

      def get_alive_channels
        @topic.top_channels(5).delete_if {|ch| ch.nil?}
      end
    end
  end
end
