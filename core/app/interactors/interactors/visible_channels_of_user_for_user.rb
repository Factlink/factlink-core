module Interactors
  class VisibleChannelsOfUserForUser
    include Pavlov::Interactor
    include Pavlov::CanCan

    arguments :user

    def execute
      channels_with_authorities.map do |ch, authority|
        kill_channel(ch, authority, containing_channel_ids(ch), @user)
      end
    end

    def channels_with_authorities
      authorities = query :creator_authorities_for_channels, visible_channels
      visible_channels.zip authorities
    end

    def visible_channels
      @visible_channels ||= query :visible_channels_of_user, @user
    end

    def containing_channel_ids(channel)
      query :containing_channel_ids_for_channel_and_user, channel.id, @options[:current_user].graph_user_id
    end

    def kill_channel(ch, owner_authority, containing_channel_ids, user)
      extra_fields = {
        owner_authority: owner_authority,
        containing_channel_ids: containing_channel_ids,
        created_by_user: kill_user(user)
      }
      
      extra_fields[:unread_count] = ch.unread_count if user == @options[:current_user]

      KillObject.channel ch, extra_fields
    end

    def kill_user(user)
      KillObject.user user,
        stream_id: user.graph_user.stream_id,
        avatar_url_32: user.avatar_url(size: 32)
    end

    def authorized?
      can? :index, Channel
    end
  end
end
