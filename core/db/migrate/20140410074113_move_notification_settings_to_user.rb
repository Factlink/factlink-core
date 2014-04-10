class MoveNotificationSettingsToUser < Mongoid::Migration
  def self.up
    User.all.each do |user|
      user['notification_settings_edit_token'] =
        user['user_notification']['notification_settings_edit_token']
      user.save!
    end
  end

  def self.down
  end
end
