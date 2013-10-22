class ActiveUsersAreSetUp < Mongoid::Migration
  def self.up
    # Don't use the actual User.active scope, as that also includes "set_up: true"
    # Also, in theory non-approved users and non-confirmed users can also be "set-up"
    User.where(:agrees_tos => true).where(:full_name.ne => nil).each do |user|
      user.set_up = true
      user.save # silently fail on users that don't validate -- they are obviously not set up!
    end
  end

  def self.down
  end
end
