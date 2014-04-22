module Backend
  module Notifications
    extend self

    def subscribe(user:, type:)
      set_subscription(user: user, type: type, value: true)
    end

    def unsubscribe(user:, type:)
      if type.to_s == 'all'
        unsubscribe_all(user: user)
      else
        set_subscription(user: user, type: type, value: false)
      end
    end

    def unsubscribe_all(user:)
      possible_subscriptions.each do |type|
        set_subscription(user: user, type: type, value: false)
      end
      true
    end
    private :unsubscribe_all # can't use prefix syntax, ruby 2.1.0 bug, fixed in 2.1.1

    def users_receiving(type:)
      check_type!(type)

      User.where("confirmed_at IS NOT NULL").where(:"receives_#{type}" => true)
    end

    def reset_edit_token(user:)
      user.notification_settings_edit_token =
        generate_token(:notification_settings_edit_token)
    end

    def can_receive?(user:, type:)
      check_type!(type)

      user.confirmed? && user[:"receives_#{type}"]
    end

    private def possible_subscriptions
      %w(digest mailed_notifications)
    end

    private def check_type!(type)
      fail "Not allowed" unless possible_subscriptions.include? type
    end

    private def set_subscription(user:, type:, value:)
      check_type!(type)
      return false if user[:"receives_#{type}"] == value

      user.update_attribute(:"receives_#{type}", value)

    end

    # adapted from Devise:
    # Generate a token by looping and ensuring does not already exist.
    private def generate_token(column)
      loop do
        token = Devise.friendly_token
        break token if User.where({ column => token }).empty?
      end
    end
  end
end
