class RemoveLastInteractionAt < Mongoid::Migration
  def self.up
    User.all.each do |user|
      user.remove_attribute(:last_interaction_at)
    end
  end

  def self.down
  end
end
