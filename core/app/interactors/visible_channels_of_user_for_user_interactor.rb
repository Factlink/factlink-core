# TODO: use pavlov
class VisibleChannelsOfUserForUserInteractor
  include Pavlov::Helpers

  def initialize(user, current_user, options={})
    @user = user
    @current_user = current_user
    #options[:current_user] = current_user
  end

  def pavlov_options
    {current_user: @current_user}
  end

  def execute
    channels = visible_channels(@user, @current_user)
    killed_user = kill_user(@user)

    topics_by_slug_title = all_topics_by_slug_title(channels)

    channels.map do |ch|
      topic = topics_by_slug_title[ch.slug_title]
      topic_authority = query :authority_on_topic_for, topic, @user
      containing_channel_ids = query :containing_channel_ids_for_channel_and_user, ch.id, @current_user.graph_user_id

      KillObject.channel ch,
        owner_authority: topic_authority,
        containing_channel_ids: containing_channel_ids,
        created_by_user: killed_user
    end
  end

  def kill_user(user)
    user_stream_id = user.graph_user.stream_id
    KillObject.user user,
      stream_id: user_stream_id,
      avatar_url_32: user.avatar_url(size: 32)
  end

  def all_topics_by_slug_title(channels)
    wrap_with_slug_titles(topics_for_channels(channels))
  end

  #QUERY
  def topics_for_channels(channels)
    query :topics_for_channels, channels
  end

  def wrap_with_slug_titles(array)
    array.each_with_object({}) {|u, hash| hash[u.slug_title] = u}
  end

  #QUERY
  def visible_channels user, current_user
    query :visible_channels_of_user, user
  end

end
