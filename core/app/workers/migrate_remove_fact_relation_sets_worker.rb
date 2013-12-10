class MigrateRemoveFactRelationSetsWorker
  @queue = :aaa_migration

  def self.perform
    Redis.current.del "", *Redis.current.keys("Fact:*:supporting_facts")

    # Also removes the *UNION* indexes
    Redis.current.del "", *Redis.current.keys("Fact:*:weakening_facts")
  end
end
