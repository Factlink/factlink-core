require_relative '../../pavlov'
require_relative '../../queries/channels'

module Interactors
  module Channels
    class ChannelSuggestions
      include Pavlov::Interactor

      def execute
        query "channels/channel_suggestions"
      end

      def authorized?
        @options[:current_user]
      end
    end
  end
end
