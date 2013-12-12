class MigrateRemoveAuthoritiesWorker
  @queue = :aaa_migration

  def self.perform
    Redis.current.del "", *Redis.current.keys("Authority:*")
  end

end
