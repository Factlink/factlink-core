require_relative '../../pavlov'

module Queries
  module Channels
    class ChannelSuggestions
      include Pavlov::Query

      def execute
        current_graph_user.editable_channels_by_authority(suggestion_count)
      end

      def suggestion_count
        3
      end

      def current_graph_user
        @options[:current_user].graph_user
      end

      def authorized?
        @options[:current_user]
      end
    end
  end
end
