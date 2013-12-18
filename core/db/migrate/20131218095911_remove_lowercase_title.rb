class RemoveLowercaseTitle < Mongoid::Migration
  def self.up
    Channel.all.ids.each do |channel_id|
      Channel.key[channel_id].hdel(:lowercase_title)
    end
  end

  def self.down
  end
end
