class DeleteBasefactRemnants < Mongoid::Migration
  def self.up
    db = Redis.current
    basefact_keys = db.keys("Basefact:*")
    deleted_key_count = db.del(*basefact_keys)
    puts "Deleted #{deleted_key_count} keys."
  end

  def self.down
    #do nothing:can't recreated deleted stuff.
  end
end
