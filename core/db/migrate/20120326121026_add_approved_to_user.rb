class AddApprovedToUser < Mongoid::Migration
  def self.up
    say_with_time "approving current users" do
      User.all.each do |user|
        user.approved = true
        user.save
      end
    end
  end

  def self.down
    say_with_time "removing :approved field from User" do
      User.all.each do |user|
        user.unset(:approved)
      end
    end
  end
end