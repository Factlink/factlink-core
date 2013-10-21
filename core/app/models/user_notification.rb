class UserNotification
  include Mongoid::Document
  embedded_in :user

  field :notification_settings_edit_token, type: String

  def subscribe(type)
    set_subscription type, true
  end

  def unsubscribe(type)
    return unsubscribe_all if type.to_s == 'all'
    set_subscription type, false
  end

  def unsubscribe_all
    self.class.possible_subscriptions.each do |type|
      set_subscription type, false
    end
    true
  end

  def reset_notification_settings_edit_token
    self.notification_settings_edit_token = self.class.notification_settings_edit_token
  end

  def can_receive? type
    raise "Not allowed" unless self.class.possible_subscriptions.include? type

    user.confirmed? && user[:"receives_#{type}"]
  end

  def self.possible_subscriptions
    %w(digest mailed_notifications)
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

  def self.users_receiving(type)
    raise "Not allowed" unless possible_subscriptions.include? type

    User.where(:confirmed_at.ne => nil).where(:"receives_#{type}" => true)
  end

  private

  def set_subscription type, value
    raise "Not allowed" unless self.class.possible_subscriptions.include? type
    return false if user[:"receives_#{type}"] == value

    user.update_attribute(:"receives_#{type}", value)
  end
end
