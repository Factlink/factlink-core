class CleanupActivitiesWorker
  include SuckerPunch::Job

  def perform
    Activity.all.each do |a|
      unless a.still_valid?
        a.destroy
      end
    end
  end
end
