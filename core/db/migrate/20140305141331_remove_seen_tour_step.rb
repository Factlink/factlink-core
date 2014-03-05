class RemoveSeenTourStep < Mongoid::Migration
  def self.up
    User.all.each do |user|
      user.remove_attribute(:seen_tour_step)
    end
  end

  def self.down
  end
end
