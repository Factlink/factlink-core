class RemoveFactsChannels < Mongoid::Migration
  def self.up
    Redis.current.keys('Fact:*:channels').each do |key|
      Redis.current.del key
    end
  end

  def self.down
  end
end
