class RemoveFactCreator < Mongoid::Migration
  def self.up
    created_by_indices = Ohm.redis.keys('Fact:created_by_id:*')
    created_by_indices.each do |key|
      Redis.current.del key
    end

    # remove values
    Fact.all.ids.each do |fact_id|
      Fact.key[fact_id][:created_by_id].del
    end

    GraphUser.all.ids.each do |gu_id|
      GraphUser.key[gu_id][:sorted_created_facts].del
    end
  end

  def self.down
  end
end
