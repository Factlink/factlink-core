class RemoveFirstFactlinkTourStep < Mongoid::Migration
  def self.up
    User.where(seen_tour_step: :create_your_first_factlink).each do |user|
      user.seen_tour_step = :install_extension
      user.save!(validate: false)
    end
  end

  def self.down
  end
end
