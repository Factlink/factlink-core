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
    channels
  end
end
