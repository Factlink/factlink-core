# TODO: use pavlov
class VisibleChannelsOfUserForUserInteractor
  include Pavlov::Helpers

  def initialize(user, current_user, options={})
    @user = user
    @current_user = current_user
  end

  def execute
    channels = @user.graph_user.real_channels
    unless @user == @current_user
      channels = channels.keep_if {|ch| ch.sorted_cached_facts.count > 0 }
    end

    user_stream_id = @user.graph_user.stream_id
    user = KillObject.user @user,
      stream_id: user_stream_id,
      avatar_url_32: @user.avatar_url(size: 32)

    channels.map do |ch|
      topic_authority = query :authority_on_topic_for, ch.slug_title, @user
      containing_channel_ids = query :containing_channel_ids_for_channel_and_user, ch.id, @current_user.graph_user_id

      KillObject.channel ch,
        owner_authority: topic_authority,
        containing_channel_ids: containing_channel_ids,
        created_by_user: user
    end
  end
end
