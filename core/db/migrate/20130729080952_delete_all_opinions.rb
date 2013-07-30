class DeleteAllOpinions < Mongoid::Migration
  def self.up
    Redis.current.del "", *Redis.current.keys("Opinion:*")
    Redis.current.del "", *Redis.current.keys("Basefact:opinion_id*")
    Redis.current.del "", *Redis.current.keys("Basefact:evidence_opinion_id*")
    Redis.current.del "", *Redis.current.keys("Basefact:user_opinion_id*")
    Redis.current.del "", *Redis.current.keys("Basefact:influencing_opinion_id*")

    basefact_namespace = Nest.new("Basefact")
    basefact_namespace["all"].smembers.each do |id|
      basefact_key = basefact_namespace[id]
      basefact_key.hdel "opinion_id"
      basefact_key.hdel "evidence_opinion_id"
      basefact_key.hdel "user_opinion_id"
      basefact_key.hdel "influencing_opinion_id"
    end
  end

  def self.down
  end
end
