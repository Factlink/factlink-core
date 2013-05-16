class RemoveTopicTopChannels < Mongoid::Migration
  def self.up
    Topic.all.each do |topic|
      Nest.new(:new_topic)[Topic.first.id][:top_channels_with_fact].del
    end
  end

  def self.down
  end
end
