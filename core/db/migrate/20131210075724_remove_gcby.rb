class RemoveGcby < Mongoid::Migration
  def self.up
    Redis.current.keys('FactRelation:gcby:*').each do |key|
      Redis.current.del key
    end
  end

  def self.down
  end
end
