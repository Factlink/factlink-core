class RemoveTopUsers < Mongoid::Migration
  def self.up
    GraphUser.all.ids.each do |gu_id|
      gu = GraphUser[gu_id]
      gu.key.hdel :interestingness
    end
    GraphUser.key[:top_users].del
  end

  def self.down
  end
end
