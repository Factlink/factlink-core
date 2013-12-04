class RemoveFactGraphOpinionsWorker
  @queue = :aaa_migration

  def self.perform
    Redis.current.del "", *Redis.current.keys("FactGraphOpinion:*")
  end

end
