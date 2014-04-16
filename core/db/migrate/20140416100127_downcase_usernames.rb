class DowncaseUsernames < Mongoid::Migration
  def self.up
    User.all.each do |user|
      user.username = user.username.downcase
      user.save!
    end
  end

  def self.down
  end
end
