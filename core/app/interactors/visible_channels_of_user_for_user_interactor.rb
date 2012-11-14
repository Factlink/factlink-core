# TODO: use pavlov
class VisibleChannelsOfUserForUserInteractor
  include Pavlov::Interactor
  include Pavlov::CanCan

  arguments :user

  def execute
    channels_with_authorities.map do |ch, authority|
      kill_channel(ch, authority,
                   containing_channel_ids(ch), @user)
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

  def kill_channel(ch, topic_authority, containing_channel_ids, user)
    KillObject.channel ch,
      owner_authority: topic_authority,
      containing_channel_ids: containing_channel_ids,
      created_by_user: kill_user(user)
  end

  def kill_user(user)
    KillObject.user user,
      stream_id: user.graph_user.stream_id,
      avatar_url_32: user.avatar_url(size: 32)
  end

  def authorized?
    can? :index, Channel
    true
  end
end
