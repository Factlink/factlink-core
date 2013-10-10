class AddUserNotificationDocument < Mongoid::Migration
  def self.up
    User.active.each do |user|
      user.user_notification.reset_notification_settings_edit_token
      user.save!
    end
  end

  def self.down
  end
end
