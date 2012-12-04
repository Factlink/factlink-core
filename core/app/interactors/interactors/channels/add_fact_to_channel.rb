module Interactors
  module Channels
    class AddFactToChannel
      include Pavlov::Interactor

      arguments :fact, :channel

      def execute
        command :"channels/add_fact_to_channel", @fact, @channel

        command :"create_activity", current_graph_user, :added_fact_to_channel, @fact, @channel
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
