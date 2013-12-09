# Abstract implementation to get a list of channels
# subclass and implement get_alive_channels to return a list
# of ohm channel models

require_relative '../../util/can_can'

module Interactors
  module Channels
    class Index
      include Pavlov::Interactor
      include Util::CanCan

      def execute
        visible_channels.map do |ch|
          graph_user = channel_graph_user(ch)
          dead_user = dead_user_for_graph_user(graph_user)

          kill_channel(ch, dead_user)
        end
      end

      def channel_graph_user(channel)
        channel.created_by
      end

      def dead_user_for_graph_user(graph_user)
        @dead_user_for_graph_user ||= {}
        @dead_user_for_graph_user[graph_user.user_id] ||=
          query(:users_by_ids, user_ids: [graph_user.user_id])
            .fetch(0, :dead_user_for_graph_user_not_found)
      end

      def visible_channels
        @visible_channels ||= get_alive_channels
      end

      def get_alive_channels
        fail "Channels::Index is abstract, subclasses should implement get_alive_channels"
      end

      def kill_channel(ch, dead_user)
        KillObject.channel ch,
          created_by_user: dead_user
      end

      def authorized?
        can? :index, Channel
      end
    end
  end
end
