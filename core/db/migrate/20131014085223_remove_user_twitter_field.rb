class RemoveUserTwitterField < Mongoid::Migration
  def self.up
    User.all.update_all(twitter: nil)
  end

  def self.down
  end
end
