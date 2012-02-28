class ProcessActivity
  @queue = :activity_operations

  def self.perform(id)
    activity = Activity[id]
    Activity::Listener.all.each do |listener|
      listener.process activity
    end
  end
end