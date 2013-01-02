class RemoveChannelsByAuthority < Mongoid::Migration
  def self.up
    GraphUser.all.ids.each do |gu_id|
      gu = GraphUser[gu_id]
      gu.key[:channels_by_authority].del
    end
  end

  def self.down
  end
end

