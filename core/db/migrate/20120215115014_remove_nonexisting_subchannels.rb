class RemoveNonexistingSubchannels < Mongoid::Migration
  def self.up
    Channel.all.each do |ch|
      ch.contained_channels.clean_non_existing if ch.type == 'channel'
    end
  end

  def self.down
  end
end