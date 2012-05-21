class ResetChannelsByAuthority < Mongoid::Migration
  def self.up
    GraphUser.all.each do |gu|
      gu.channels_by_authority.key.del
      gu.editable_channels.each do |ch|
        gu.channels_by_authority.add ch
      end
    end
  end

  def self.down
  end
end