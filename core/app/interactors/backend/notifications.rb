module Backend
  module Notifications
    extend self

    def subscribe(user:, type:)
      Backend::Notifications.set_subscription \
        user: user,
        type: type,
        value: true

    end

    def unsubscribe(user:, type:)
      return Backend::Notifications.unsubscribe_all(user: user) if type.to_s == 'all'
      Backend::Notifications.set_subscription \
        user: user,
        type: type,
        value: false
    end

    def unsubscribe_all(user:)
      Backend::Notifications.possible_subscriptions.each do |type|
        Backend::Notifications.set_subscription \
          user: user,
          type: type,
          value: false
      end
      true
    end
    #private :unsubscribe_all

    def users_receiving(type:)
      fail "Not allowed" unless possible_subscriptions.include? type

      User.where(:confirmed_at.ne => nil).where(:"receives_#{type}" => true)
    end

    def reset_edit_token(user:)
      user.user_notification.notification_settings_edit_token =
        generate_token(:notification_settings_edit_token)
    end

    def can_receive?(user:, type:)
      fail "Not allowed" unless possible_subscriptions.include?(type)

      user.confirmed? && user[:"receives_#{type}"]
    end

    #private
    def possible_subscriptions
      %w(digest mailed_notifications)
    end

    # private
    def set_subscription(user:, type:, value:)
      fail "Not allowed" unless possible_subscriptions.include? type
      return false if user[:"receives_#{type}"] == value

      user.update_attribute(:"receives_#{type}", value)

    end

    # adapted from Devise:
    # Generate a token by looping and ensuring does not already exist.
    private def generate_token(column)
      loop do
        token = Devise.friendly_token
        break token if UserNotification.find({ column => token }).empty?
      end
    end
  end
end
