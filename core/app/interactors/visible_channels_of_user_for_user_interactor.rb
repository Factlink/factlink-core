# TODO: use pavlov
class VisibleChannelsOfUserForUserInteractor

  def initialize(user, current_user, options={})
    @user = user
    @current_user = current_user
  end

  def execute
    channels = @user.graph_user.real_channels
    unless @user == @current_user
      channels = @channels.keep_if {|ch| ch.sorted_cached_facts.count > 0 }
    end
    channels.map do |ch|
      Hashie::Mash.new({
        type: ch.type,
        title: ch.title,
        unread_count: ch.unread_count,
        id: ch.id,
        has_authority?: ch.has_authority?,
        slug_title: ch.slug_title,
        created_by_id: ch.created_by_id,
        inspectable?: ch.inspectable?,
        editable?: ch.editable?,
        topic: ch.topic
      })
    end
  end
end
