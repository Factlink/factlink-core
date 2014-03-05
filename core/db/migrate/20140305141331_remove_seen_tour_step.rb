class RemoveSeenTourStep < Mongoid::Migration
  def self.up
    User.where(set_up: false).destroy_all

    if User.where(set_up: false).size > 0
      fail "There are still some non-set-up users left"
    end

    if User.where(suspended: true).size > 0
      fail "There are still some suspended users left"
    end

    User.all.each do |user|
      user.remove_attribute(:seen_tour_step)
      user.remove_attribute(:suspended)
    end
  end

  def self.down
  end
end
