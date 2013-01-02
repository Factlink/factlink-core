class DiscontinueDiscontinued < Mongoid::Migration
  def self.up
    Channel.all.ids.each do |id|
      ch = Channel[id]
      ch.key.hdel :discontinued
    end
  end

  def self.down
  end
end
