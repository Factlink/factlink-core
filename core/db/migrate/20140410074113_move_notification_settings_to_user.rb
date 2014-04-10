class MoveNotificationSettingsToUser < Mongoid::Migration
  def self.up
    User.all.each do |user|
      if user['user_notification'].nil?
        Backend::Notifications.reset_edit_token(user: user)
      else
        user['notification_settings_edit_token'] ||=
          user['user_notification']['notification_settings_edit_token']
      end
      user.save!
    end
  end

  def self.down
  end
end
