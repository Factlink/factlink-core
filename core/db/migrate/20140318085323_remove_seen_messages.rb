class RemoveSeenMessages < Mongoid::Migration
  def self.up
    User.all.each do |user|
      Redis.current.del user.seen_messages.key
    end
  end

  def self.down
  end
end
