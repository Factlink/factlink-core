class AddAgreeToTosField < Mongoid::Migration
  def self.up
    say_with_time "Adding :agrees_tos field to User" do
      User.all.each do |user|
        user.agrees_tos = false
        user.save
      end
    end
  end

  def self.down
    say_with_time "Removing :agrees_tos field from User" do
      User.all.each do |user|
        user.agrees_tos = nil
        user.save
      end
    end
  end
end