class RemoveSeenMessages < Mongoid::Migration
  def self.up
    db = Redis.current
    seen_messages_keys = db.keys("*:seen_messages")
    if seen_messages_keys.size > 0 then
      deleted_key_count = db.del(*seen_messages_keys)
      puts "Deleted #{deleted_key_count} keys."
    end
  end

  def self.down
  end
end
