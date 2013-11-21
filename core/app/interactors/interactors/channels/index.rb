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
        channels_with_authorities.map do |ch, authority|
          graph_user = channel_graph_user(ch)
          dead_user = dead_user_for_graph_user(graph_user)

          kill_channel(ch, authority, containing_channel_ids(ch), dead_user)
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

      def channels_with_authorities
        authorities = query(:'creator_authorities_for_channels',
                                channels: visible_channels)
        visible_channels.zip authorities
      end

      def visible_channels
        @visible_channels ||= get_alive_channels
      end

      def get_alive_channels
        raise "Channels::Index is abstract, subclasses should implement get_alive_channels"
      end

      def containing_channel_ids(channel)
        return [] unless pavlov_options[:current_user]

        query(:'containing_channel_ids_for_channel_and_user',
                  channel_id: channel.id,
                  graph_user_id: pavlov_options[:current_user].graph_user_id)
      end

      def kill_channel(ch, owner_authority, containing_channel_ids, dead_user)
        KillObject.channel ch,
          owner_authority: owner_authority,
          containing_channel_ids: containing_channel_ids,
          created_by_user: dead_user
      end

      def authorized?
        can? :index, Channel
      end
    end
  end
end
