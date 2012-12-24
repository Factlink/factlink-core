class RemoveFollowingAllChannels < Mongoid::Migration
  def self.up
    say_with_time "Removing follow all channels" do
      Channel.all.each do |channel|
        channel.contained_channels.each do |contained|
          if !contained.is_real_channel?
            channel.remove_channel(contained)
          end
        end
      end
    end
  end

  def self.down

  end
end
