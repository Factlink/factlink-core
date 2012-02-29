class LowercaseUsernames < Mongoid::Migration
  def self.up
    say_with_time "lowercasing usernames" do
      User.all.each do |user|
        user.username.downcase!
        user.save
      end
    end
  end

  def self.down
  end
end