class ActiveUsersHaveSeenTheTour < Mongoid::Migration
  def self.up
    User.active.each do |user|
      user.seen_the_tour = true
      user.save
    end
  end

  def self.down
  end
end
