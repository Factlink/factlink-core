class RemoveHandpickedTourUsers < Mongoid::Migration
  def self.up
    Nest.new(:user)[:handpicked_tour_users].del
  end

  def self.down
  end
end
