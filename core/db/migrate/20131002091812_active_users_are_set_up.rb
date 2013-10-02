class ActiveUsersAreSetUp < Mongoid::Migration
  def self.up
    User.approved.where(:agrees_tos => true).where(:first_name.ne => nil).each do |user|
      user.set_up = true
      user.save!
    end
  end

  def self.down
  end
end
