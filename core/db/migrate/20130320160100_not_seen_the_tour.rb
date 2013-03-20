class NotSeenTheTour < Mongoid::Migration
  def self.up
    User.where(seen_the_tour: false)
        .update_all(seen_tour_step: nil)
  end

  def self.down
  end
end
