class GranularSeenTheTour < Mongoid::Migration
  def self.up
    User.where(seen_the_tour: true)
        .update_all(seen_tour_step: 'tour_done')
  end

  def self.down
  end
end
