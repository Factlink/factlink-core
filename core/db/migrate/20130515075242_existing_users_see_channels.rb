class ExistingUsersSeeChannels < Mongoid::Migration
  def self.up
    User.seen_the_tour.each do |u|
      u.features << :sees_channels
    end
  end

  def self.down
    User.all.each do |u|
      u.features.delete :sees_channels
    end
  end
end
