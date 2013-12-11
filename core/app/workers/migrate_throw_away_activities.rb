class MigrateThrowAwayActivities
  @queue = :aaa_migration

  def self.perform
    Activity.find(action: :created_channel).each do |a|
      a.delete
    end
  end
end
