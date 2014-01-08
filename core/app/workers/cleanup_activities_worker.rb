class CleanupActivitiesWorker
  @queue = :zzz_janitor

  def self.perform
    Activity.all.ids.each do |id|
      a = Activity[id]
      unless a.still_valid?
        a.delete
      end
    end
  end
end
