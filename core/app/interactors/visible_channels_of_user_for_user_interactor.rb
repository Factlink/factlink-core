# TODO: use pavlov
class VisibleChannelsOfUserForUserInteractor
  include Pavlov::Interactor

  arguments :user

  def execute
    visible_channels.map do |ch|
      kill_channel(ch, topic_authority_for(ch),
                   containing_channel_ids(ch), @user)
    end
  end

  def visible_channels
    @visible_channels ||= query :visible_channels_of_user, @user
  end

  def topic_authority_for(ch)
    topic = topics_by_slug_title[ch.slug_title]
    query :authority_on_topic_for, topic, @user
  end

  def topics_by_slug_title
     @topics_by_slug_title ||= all_topics_by_slug_title(visible_channels)
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

  def all_topics_by_slug_title(channels)
    topics = query :topics_for_channels, channels
    wrap_with_slug_titles(topics)
  end

  def wrap_with_slug_titles(array)
    array.each_with_object({}) {|u, hash| hash[u.slug_title] = u}
  end

  def authorized?
    true
  end
end
