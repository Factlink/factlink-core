class UsersNotificationToken < Mongoid::Migration
  def self.up
    User.each do |user|
      user.reset_notification_settings_edit_token
      user.save!
    end
  end

  def self.down
  end
end
