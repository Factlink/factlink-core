class RemoveSeenTourStep < Mongoid::Migration
  def self.up
    User.all.each do |user|
      user.remove_attribute(:seen_tour_step)
      user.remove_attribute(:suspended)
      user.remove_attribute(:set_up)
    end
  end

  def self.down
  end
end
