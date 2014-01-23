class RemoveOldAuthorities < Mongoid::Migration
  def self.up
    old_authority_keys = Ohm.redis.keys('Authority+NEW*')

    old_authority_keys.each do |key|
      Redis.current.del key
    end
  end

  def self.down
  end
end
