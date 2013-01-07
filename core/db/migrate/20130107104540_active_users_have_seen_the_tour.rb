class ActiveUsersHaveSeenTheTour < Mongoid::Migration
  def self.up
    User.active.update_all(seen_the_tour: true)
  end

  def self.down
  end
end
