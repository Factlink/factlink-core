class Channel < OurOhm
end

class RemoveChannelDescription < Mongoid::Migration
  def self.up
    Channel.all.each do |ch|
      ch.key.hdel(:description)
    end
  end

  def self.down
  end
end