class RemoveTopTopics < Mongoid::Migration
  def self.up
    User.all.each do |user|
      Nest.new(:user)[:topics_by_authority][user.id].del
    end
  end

  def self.down
  end
end
