class AddLastReadActivitiesOnToUser < Mongoid::Migration
  def self.up
    say_with_time "Adding :last_read_activities_on field to all Users" do
      User.all.each do |user|
        user.last_read_activities_on = 0
        user.save
      end
    end
  end

  def self.down
    say_with_time "Removing :last_read_activities_on from all Users" do
      user.unset(:last_read_activities_on)
    end
  end
end