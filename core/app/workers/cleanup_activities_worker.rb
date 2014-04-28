class CleanupActivitiesWorker
  @queue = :zzz_janitor

  def self.perform
    Activity.all.each do |a|
      unless a.still_valid?
        a.destroy
      end
    end
  end
end
