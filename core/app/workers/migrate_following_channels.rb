class MigrateFollowingChannels
  @queue = :aaa_migration

  def self.perform(channel_id)
    ch = Channel[channel_id]
    to_follow_id = ch.created_by_id
    ch.key[:containing_channels].smembers.each do |follower_ch_id|
      follower_id = Channel[follower_ch_id].created_by_id
      Pavlov.command :'users/follow_user',
        graph_user_id: follower_id.to_s,
        user_to_follow_graph_user_id: to_follow_id.to_s
    end
    ch.key[:containing_channels].del
    ch.key[:contained_channels].del
  end

end
