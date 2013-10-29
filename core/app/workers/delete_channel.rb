# This class removes a channel. This is put in a worker because
# a channel also cleans up its activities, which can be rather slow
class DeleteChannel
  @queue = :migration

  def self.perform(channel_id)
    channel = Channel[channel_id]
    return unless channel
    channel.delete
  end
end
