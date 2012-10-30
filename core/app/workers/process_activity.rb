class ProcessActivity
  @queue = :activity_operations

  def self.perform(id)
    activity = Activity[id]
    if activity and activity.still_valid?
      Activity::Listener.all.each do |key, listener|
        listener.process activity
      end
    end
  end
end
