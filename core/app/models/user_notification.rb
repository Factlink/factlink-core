class UserNotification
  include Mongoid::Document
  embedded_in :user

  def possible_subscriptions
    %w(digest mailed_notifications)
  end

  def unsubscribe(type)
    raise "Not allowed" unless possible_subscriptions.include? type
    return false unless user[:"receives_#{type}"]

    user.update_attribute(:"receives_#{type}", false)
  end

  field :notification_settings_edit_token, type: String
  def reset_notification_settings_edit_token
    self.notification_settings_edit_token = self.class.notification_settings_edit_token
  end

  def self.notification_settings_edit_token
    generate_token(:notification_settings_edit_token)
  end

  # adapted from Devise:
  # Generate a token by looping and ensuring does not already exist.
  def self.generate_token(column)
    loop do
      token = Devise.friendly_token
      break token if self.find({ column => token }).empty?
    end
  end
end
