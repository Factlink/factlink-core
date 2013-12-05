class ProcessActivity
  @queue = :mmm_activity_operations

  def self.perform(id)
    activity = Activity[id]
    if activity and activity.still_valid?
      Activity::Listener.all.each do |key, listeners|
        listeners.each do |listener|
          listener.process activity
        end
      end
    end
  end
end
