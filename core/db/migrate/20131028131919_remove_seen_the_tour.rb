class RemoveSeenTheTour < Mongoid::Migration
  def self.up
    User.all.each do |u|
      u.remove_attribute(:seen_the_tour)
      u.save(validate: false)
    end
  end

  def self.down
    fail "This is a destructive migration."
  end
end
