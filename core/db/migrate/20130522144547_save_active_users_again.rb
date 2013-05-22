class SaveActiveUsersAgain < Mongoid::Migration
  def self.up
    User.active.each do |user|
      user.save
    end
  end

  def self.down
  end
end
