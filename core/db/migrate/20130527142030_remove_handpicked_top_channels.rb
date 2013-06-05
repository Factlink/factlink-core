class RemoveHandpickedTopChannels < Mongoid::Migration
  def self.up
    Nest.new(:top_channels)[:handpicked_channels].del
  end

  def self.down
  end
end
