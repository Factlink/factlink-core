class RemoveDiscontinuedChannels < Mongoid::Migration
  def self.up
    #Channel.find(discontinued: 'true').each do |ch|
    #  ch.delete
    #end
  end

  def self.down
  end
end
