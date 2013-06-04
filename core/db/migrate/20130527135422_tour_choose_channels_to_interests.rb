class TourChooseChannelsToInterests < Mongoid::Migration
  def self.up
    User.where(seen_tour_step: 'choose_channels').each do |user|
      user.seen_tour_step = 'interests'
      user.save validate: false
    end
  end

  def self.down
  end
end
