class Channel < OurOhm
  set :contained_channels, Channel
  set :containing_channels, Channel
end

class InitializeContainingChannels < Mongoid::Migration
  def self.up
    Channel.all.each do |ch|
      ch.contained_channels.each do |sub_ch|
        sub_ch.containing_channels << ch
      end
    end
  end

  def self.down
  end
end