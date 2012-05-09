class RestoreFactsInChannels < Mongoid::Migration
  def self.up
    say_with_time "Preparing to repopulate channels with manually added facts" do
      Channel.all.each do |channel|
        Resque.enqueue(ChannelEnsureInternalInCached,channel.id)
      end
    end
    
  end

  def self.down
  end
end