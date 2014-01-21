class RemoveOldAuthorities < Mongoid::Migration
  def self.up
    old_authority_keys = Ohm.redis.keys('Authority+NEW*')

    Redis.current.del *old_authority_keys unless old_authority_keys.empty?
  end

  def self.down
  end
end
